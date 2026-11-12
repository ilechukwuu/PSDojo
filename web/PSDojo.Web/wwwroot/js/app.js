(function () {
  'use strict';

  var strings = window.PSDojoStrings;
  var view = document.getElementById('view');
  var nav = document.getElementById('nav');
  var userBox = document.getElementById('user');
  var state = { me: null, lang: 'en', editor: null, monacoReady: null };

  function readStore(key) {
    try { return window.localStorage.getItem(key); } catch (error) { return null; }
  }

  function writeStore(key, value) {
    try { window.localStorage.setItem(key, value); } catch (error) { return; }
  }

  function removeStore(key) {
    try { window.localStorage.removeItem(key); } catch (error) { return; }
  }

  function t(key) {
    var text = (strings[state.lang] && strings[state.lang][key]) || strings.en[key] || key;
    for (var index = 1; index < arguments.length; index++) {
      text = text.replace('{' + (index - 1) + '}', arguments[index]);
    }
    return text;
  }

  function loc(pair) {
    if (!pair) { return ''; }
    return pair[state.lang] || pair.en || '';
  }

  function el(tag, attributes, children) {
    var node = document.createElement(tag);
    Object.keys(attributes || {}).forEach(function (name) {
      var value = attributes[name];
      if (value === null || value === undefined || value === false) { return; }
      if (name === 'class') { node.className = value; }
      else if (name === 'text') { node.textContent = value; }
      else if (name === 'html') { node.innerHTML = value; }
      else if (name.indexOf('on') === 0) { node.addEventListener(name.substring(2), value); }
      else if (value === true) { node.setAttribute(name, ''); }
      else { node.setAttribute(name, value); }
    });
    [].concat(children || []).forEach(function (child) {
      if (child === null || child === undefined || child === false) { return; }
      node.appendChild(typeof child === 'string' ? document.createTextNode(child) : child);
    });
    return node;
  }

  function api(path, options) {
    var settings = options || {};
    var request = { method: settings.method || 'GET', headers: { 'Accept': 'application/json' }, credentials: 'same-origin' };
    if (request.method !== 'GET') {
      request.headers['X-PSDojo-Request'] = '1';
      request.headers['Content-Type'] = 'application/json';
      request.body = JSON.stringify(settings.body === undefined ? {} : settings.body);
    }
    return fetch('api/' + path, request).then(function (response) {
      return response.text().then(function (text) {
        var data = {};
        try { data = text ? JSON.parse(text) : {}; } catch (error) { data = {}; }
        return { ok: response.ok, status: response.status, data: data };
      });
    });
  }

  function formatDate(value) {
    if (!value) { return ''; }
    var date = new Date(value);
    if (isNaN(date.getTime())) { return ''; }
    return date.toLocaleString(state.lang === 'de' ? 'de-DE' : 'en-GB', { dateStyle: 'medium', timeStyle: 'short' });
  }

  function setLanguage(language) {
    state.lang = language === 'de' ? 'de' : 'en';
    writeStore('psdojo.lang', state.lang);
    document.documentElement.lang = state.lang;
    document.getElementById('lang-de').className = 'lang-button' + (state.lang === 'de' ? ' active' : '');
    document.getElementById('lang-en').className = 'lang-button' + (state.lang === 'en' ? ' active' : '');
  }

  function hasRole() {
    var role = state.me ? state.me.role : '';
    return [].slice.call(arguments).indexOf(role) >= 0;
  }

  function renderChrome() {
    nav.innerHTML = '';
    userBox.innerHTML = '';
    if (!state.me || !state.me.authenticated) { return; }
    var route = window.location.hash || '#/';
    function link(hash, key, active) {
      nav.appendChild(el('a', { href: hash, class: active ? 'active' : '', text: t(key) }));
    }
    link('#/', 'navMap', route === '#/' || route.indexOf('#/exercise') === 0);
    if (hasRole('reviewer', 'admin')) { link('#/review', 'navReview', route.indexOf('#/review') === 0); }
    if (hasRole('trainer', 'admin')) { link('#/trainer', 'navTrainer', route.indexOf('#/trainer') === 0); }
    if (hasRole('admin')) { link('#/admin', 'navAdmin', route.indexOf('#/admin') === 0); }
    userBox.appendChild(el('span', { text: state.me.name + ' (' + t('role_' + state.me.role) + ')' }));
    userBox.appendChild(el('button', { type: 'button', class: 'link', text: t('logout'), onclick: logout }));
  }

  function logout() {
    api('logout', { method: 'POST' }).then(function () {
      state.me = null;
      start();
    });
  }

  function page(children, extraClass) {
    disposeEditor();
    view.innerHTML = '';
    view.appendChild(el('div', { class: 'page' + (extraClass ? ' ' + extraClass : '') }, children));
  }

  function message(kind, text) {
    return el('div', { class: 'notice ' + kind }, [el('p', { text: text })]);
  }

  function renderLogin(errorText) {
    var input = el('input', { type: 'text', id: 'login-name', autocomplete: 'username', maxlength: '64' });
    var form = el('form', {
      onsubmit: function (event) {
        event.preventDefault();
        api('login', { method: 'POST', body: { name: input.value } }).then(function (result) {
          if (result.ok) { start(); } else { renderLogin(t('loginInvalid')); }
        });
      }
    }, [
      el('label', { for: 'login-name', text: t('loginName') }),
      input,
      el('p', { class: 'muted small', text: t('loginHint') }),
      el('button', { type: 'submit', class: 'primary', text: t('loginButton') })
    ]);
    var body = state.me && state.me.nameLogin === false
      ? el('a', { class: 'button', href: 'signin', text: t('loginSso') })
      : form;
    page([el('div', { class: 'card' }, [el('h1', { text: t('loginTitle') }), errorText ? message('bad', errorText) : null, body])], 'narrow');
    if (input.focus) { input.focus(); }
  }

  function stateIcon(name) {
    return el('span', { class: 'state ' + name, title: t('state' + name.charAt(0).toUpperCase() + name.substring(1)), text: name === 'completed' ? '✓' : '' });
  }

  function renderMap() {
    api('modules').then(function (result) {
      if (!result.ok) { return page([message('bad', t('errorGeneric'))]); }
      var data = result.data;
      var children = [
        el('div', { class: 'row' }, [
          el('h1', { text: t('mapTitle') }),
          el('span', { class: 'spacer' }),
          el('span', { class: 'muted', text: t('mapProgress', data.completed, data.total) })
        ])
      ];
      if (!data.modules.length) {
        children.push(message('info', t('mapEmpty')));
      }
      [1, 2, 3, 4].forEach(function (part) {
        var modules = data.modules.filter(function (module) { return module.part === part; });
        if (!modules.length) { return; }
        children.push(el('div', { class: 'part-title', text: t('part' + part) }));
        children.push(el('div', { class: 'module-grid' }, modules.map(renderModuleCard)));
      });
      page(children);
    });
  }

  function renderModuleCard(module) {
    var percent = module.total ? Math.round(100 * module.completed / module.total) : 0;
    var items = module.exercises.map(function (exercise) {
      var title = exercise.state === 'locked'
        ? el('span', { class: 'title locked-title', title: t('lockedBy', exercise.missing.join(', ')), text: loc(exercise.title) })
        : el('a', { class: 'title', href: '#/exercise/' + exercise.id, text: loc(exercise.title) });
      return el('li', {}, [
        stateIcon(exercise.state),
        title,
        exercise.placeholder ? el('span', { class: 'badge warn', text: t('placeholder') }) : null,
        exercise.localOnly ? el('span', { class: 'badge', text: t('localOnly') }) : null,
        el('span', { class: 'badge', text: t('type_' + exercise.type) })
      ]);
    });
    var card = el('div', { class: 'card module-card' }, [
      el('div', { class: 'module-head' }, [
        el('span', { class: 'muted small', text: module.id }),
        el('h3', { text: loc(module.title) }),
        module.track === 'advanced' ? el('span', { class: 'badge accent', text: t('trackAdvanced') }) : null,
        el('span', { class: 'muted small', text: module.completed + '/' + module.total })
      ]),
      el('div', { class: 'progress' }, [el('span', { style: 'width:' + percent + '%' })]),
      el('ul', { class: 'exercise-list' }, items)
    ]);
    if (module.productionNote) {
      card.appendChild(el('hr'));
      card.appendChild(el('div', { class: 'prose', html: loc(module.productionNote) }));
    }
    return card;
  }

  function disposeEditor() {
    if (state.editor) {
      state.editor.dispose();
      state.editor = null;
    }
  }

  function loadMonaco() {
    if (state.monacoReady) { return state.monacoReady; }
    state.monacoReady = new Promise(function (resolve, reject) {
      var script = document.createElement('script');
      script.src = 'lib/monaco/vs/loader.js';
      script.onload = function () {
        var settings = { paths: { vs: 'lib/monaco/vs' } };
        if (state.lang === 'de') { settings['vs/nls'] = { availableLanguages: { '*': 'de' } }; }
        window.require.config(settings);
        window.require(['vs/editor/editor.main'], function () { resolve(window.monaco); }, reject);
      };
      script.onerror = reject;
      document.head.appendChild(script);
    });
    return state.monacoReady;
  }

  function draftKey(id) {
    return 'psdojo.code.' + state.me.name + '.' + id;
  }

  function renderExercise(id) {
    api('exercises/' + encodeURIComponent(id)).then(function (result) {
      if (result.status === 423) {
        return page([message('warn', t('locked') + ' ' + t('lockedBy', (result.data.missing || []).join(', '))), el('a', { href: '#/', text: t('backToMap') })]);
      }
      if (!result.ok) {
        return page([message('warn', t('notFound')), el('a', { href: '#/', text: t('backToMap') })]);
      }
      showExercise(result.data);
    });
  }

  function showExercise(exercise) {
    disposeEditor();
    var output = el('div', { class: 'pane-body', id: 'output' });
    var left = el('div', { class: 'pane' }, [
      el('div', { class: 'pane-head' }, [
        el('h1', { text: loc(exercise.title) }),
        exercise.placeholder ? el('span', { class: 'badge warn', text: t('placeholder') }) : null,
        el('span', { class: 'badge', text: t('type_' + exercise.type) }),
        exercise.state === 'completed' ? el('span', { class: 'badge good', text: t('stateCompleted') }) : null
      ]),
      el('div', { class: 'pane-body' }, [
        el('div', { class: 'prose', html: loc(exercise.lesson) }),
        el('hr'),
        el('div', { class: 'prose', html: loc(exercise.task) }),
        el('p', { class: 'small' }, [el('a', { href: '#/', text: t('backToMap') })])
      ])
    ]);

    var right = exercise.type === 'quiz' ? quizColumn(exercise, output) : codeColumn(exercise, output);
    view.innerHTML = '';
    view.appendChild(el('div', { class: 'workspace' }, [left, right]));
    if (exercise.type !== 'quiz') { mountEditor(exercise); }
  }

  function nextLink(exercise) {
    return exercise.next ? el('a', { class: 'button', href: '#/exercise/' + exercise.next, text: t('next') }) : null;
  }

  function quizColumn(exercise, output) {
    var form = el('form', {});
    var blocks = {};
    exercise.questions.forEach(function (question) {
      var options = loc(question.options).map(function (option, index) {
        var letter = 'abcdefgh'.charAt(index);
        return el('label', {}, [
          el('input', { type: 'radio', name: 'q' + question.id, value: letter }),
          el('span', { text: letter + ') ' + option })
        ]);
      });
      blocks[question.id] = el('div', { class: 'question' }, [el('p', { text: question.id + '. ' + loc(question.text) })].concat(options));
      form.appendChild(blocks[question.id]);
    });
    var submit = el('button', { type: 'submit', class: 'primary', text: t('quizSubmit') });
    form.addEventListener('submit', function (event) {
      event.preventDefault();
      var answers = {};
      exercise.questions.forEach(function (question) {
        var checked = form.querySelector('input[name="q' + question.id + '"]:checked');
        answers[String(question.id)] = checked ? checked.value : '';
      });
      submit.disabled = true;
      api('exercises/' + exercise.id + '/quiz', { method: 'POST', body: { answers: answers } }).then(function (result) {
        submit.disabled = false;
        output.innerHTML = '';
        if (!result.ok) { return output.appendChild(message('bad', t('errorGeneric'))); }
        var data = result.data;
        Object.keys(blocks).forEach(function (key) {
          blocks[key].className = 'question' + (data.wrong.indexOf(Number(key)) >= 0 ? ' wrong' : '');
        });
        output.appendChild(el('p', { class: 'feedback-title ' + (data.passed ? 'good' : 'bad'), text: data.passed ? t('passed') : t('notYet') }));
        output.appendChild(el('p', { text: t('quizScore', data.correct, data.total, data.score, data.passMark) }));
        if (data.wrong.length) { output.appendChild(el('p', { text: t('quizWrong', data.wrong.join(', ')) })); }
        if (data.passed) { output.appendChild(el('p', {}, [nextLink(exercise) || el('a', { href: '#/', text: t('backToMap') })])); }
      });
    });
    return el('div', { class: 'right-column' }, [
      el('div', { class: 'pane editor-pane' }, [
        el('div', { class: 'pane-head' }, [el('h1', { text: t('quiz') }), el('span', { class: 'muted small', text: t('quizIntro') })]),
        el('div', { class: 'pane-body' }, [form]),
        el('div', { class: 'toolbar' }, [el('span', { class: 'spacer' }), el('button', { type: 'button', class: 'primary', text: t('quizSubmit'), onclick: function () { form.requestSubmit(); } })])
      ]),
      el('div', { class: 'pane output-pane' }, [el('div', { class: 'pane-head' }, [el('h1', { text: t('output') })]), output])
    ]);
  }

  function executionNotice(exercise) {
    var execution = state.me.execution;
    if (exercise.localOnly) { return { title: t('offTitle'), text: t('localOnlyText') }; }
    if (execution.enabledForMe) { return null; }
    if (execution.mode === 'Pilot') { return { title: t('offTitle'), text: t('pilotText') }; }
    return { title: t('offTitle'), text: t('offText') };
  }

  function uploadControl(output) {
    var input = el('input', { type: 'file', accept: '.json,application/json', style: 'display:none' });
    input.addEventListener('change', function () {
      var file = input.files && input.files[0];
      if (!file) { return; }
      var reader = new FileReader();
      reader.onload = function () {
        var report;
        try { report = JSON.parse(String(reader.result).replace(/^﻿/, '')); } catch (error) { report = null; }
        if (!report) {
          output.innerHTML = '';
          output.appendChild(message('bad', t('uploadBad')));
          return;
        }
        api('progress/import', { method: 'POST', body: report }).then(function (result) {
          output.innerHTML = '';
          output.appendChild(result.ok
            ? message('good', t('uploadDone', result.data.matched, result.data.newlyCompleted))
            : message('bad', t('uploadBad')));
          input.value = '';
        });
      };
      reader.readAsText(file);
    });
    return [input, el('button', { type: 'button', text: t('uploadButton'), onclick: function () { input.click(); } })];
  }

  function codeColumn(exercise, output) {
    var notice = executionNotice(exercise);
    var hintsUsed = exercise.hintsUsed;
    var solutionButton = el('button', { type: 'button', text: t('solution'), disabled: hintsUsed < 3 });
    var hintButton = el('button', { type: 'button', text: t('hint') });
    var runButton = el('button', { type: 'button', text: t('run') });
    var checkButton = el('button', { type: 'button', class: 'primary', text: t('check') });

    hintButton.addEventListener('click', function () {
      api('exercises/' + exercise.id + '/hint', { method: 'POST' }).then(function (result) {
        if (!result.ok) { return; }
        hintsUsed = result.data.level;
        solutionButton.disabled = !result.data.solutionUnlocked;
        output.innerHTML = '';
        output.appendChild(el('p', { class: 'feedback-title', text: t('hintLabel', result.data.level, result.data.levels) }));
        output.appendChild(el('p', { text: loc(result.data.text) }));
      });
    });

    solutionButton.addEventListener('click', function () {
      if (!window.confirm(t('solutionConfirm'))) { return; }
      api('exercises/' + exercise.id + '/solution', { method: 'POST' }).then(function (result) {
        output.innerHTML = '';
        if (!result.ok) { return output.appendChild(message('warn', t('solutionLocked', result.data.hintsUsed || 0))); }
        output.appendChild(el('p', { class: 'feedback-title', text: t('solutionRecorded') }));
        output.appendChild(el('pre', { class: 'code', text: result.data.solution }));
      });
    });

    function execute(mode, button) {
      var code = state.editor ? state.editor.getValue() : '';
      runButton.disabled = true;
      checkButton.disabled = true;
      output.innerHTML = '';
      output.appendChild(el('p', { class: 'muted', text: mode === 'run' ? t('running') : t('checking') }));
      api('exercises/' + exercise.id + '/' + mode, { method: 'POST', body: { code: code } }).then(function (result) {
        runButton.disabled = false;
        checkButton.disabled = false;
        output.innerHTML = '';
        if (result.status === 429) { return output.appendChild(message('warn', t('rateLimited', result.data.retryAfter))); }
        if (result.status === 403) { return output.appendChild(message('warn', t('offText'))); }
        if (result.status === 503) { return output.appendChild(message('warn', t('runnerMissing'))); }
        if (!result.ok) { return output.appendChild(message('bad', t('errorGeneric'))); }
        renderRunResult(result.data, output, exercise);
      });
    }
    runButton.addEventListener('click', function () { execute('run', runButton); });
    checkButton.addEventListener('click', function () { execute('check', checkButton); });

    var resetButton = el('button', {
      type: 'button', text: t('reset'), onclick: function () {
        removeStore(draftKey(exercise.id));
        if (state.editor) { state.editor.setValue(exercise.starter); }
      }
    });

    var toolbar = el('div', { class: 'toolbar' }, [hintButton, solutionButton, resetButton, el('span', { class: 'spacer' })]);
    if (notice) {
      uploadControl(output).forEach(function (node) { toolbar.appendChild(node); });
      output.appendChild(el('div', { class: 'notice info' }, [
        el('p', {}, [el('strong', { text: notice.title })]),
        el('p', { text: notice.text }),
        el('p', { text: t('offUpload') })
      ]));
    } else {
      toolbar.appendChild(runButton);
      toolbar.appendChild(checkButton);
    }

    return el('div', { class: 'right-column' }, [
      el('div', { class: 'pane editor-pane' }, [
        el('div', { class: 'pane-head' }, [el('h1', { text: t('editor') }), el('span', { class: 'muted small', text: exercise.id + '.ps1' })]),
        el('div', { id: 'editor' }),
        toolbar
      ]),
      el('div', { class: 'pane output-pane' }, [el('div', { class: 'pane-head' }, [el('h1', { text: t('output') })]), output])
    ]);
  }

  function mountEditor(exercise) {
    var host = document.getElementById('editor');
    var saved = readStore(draftKey(exercise.id));
    var readOnly = executionNotice(exercise) !== null;
    loadMonaco().then(function (monaco) {
      if (!document.body.contains(host)) { return; }
      state.editor = monaco.editor.create(host, {
        value: readOnly ? exercise.starter : (saved || exercise.starter),
        language: 'powershell',
        automaticLayout: true,
        minimap: { enabled: false },
        fontSize: 14,
        scrollBeyondLastLine: false,
        readOnly: readOnly,
        tabSize: 4
      });
      state.editor.onDidChangeModelContent(function () {
        writeStore(draftKey(exercise.id), state.editor.getValue());
      });
    }).catch(function () {
      host.appendChild(el('pre', { class: 'code', text: exercise.starter }));
    });
  }

  function renderRunResult(data, output, exercise) {
    function field(list, label, value) {
      if (value === '' || value === null || value === undefined) { return; }
      list.appendChild(el('dt', { text: label }));
      list.appendChild(el('dd', { text: String(value) }));
    }
    if (data.mode === 'run') {
      if (data.status === 'timeout') { output.appendChild(message('warn', t('kindTimeout'))); }
      output.appendChild(el('pre', { class: 'output', text: data.output || t('noOutput') }));
      if (data.status === 'truncated') { output.appendChild(el('p', { class: 'muted small', text: t('outputTruncated') })); }
      return;
    }
    output.appendChild(el('p', { class: 'feedback-title ' + (data.passed ? 'good' : 'bad'), text: (data.passed ? t('passed') : t('notYet')) + '  ' + exercise.id }));
    if (data.passed) {
      var link = nextLink(exercise) || el('a', { href: '#/', text: t('backToMap') });
      output.appendChild(el('p', {}, [link]));
      return;
    }
    var list = el('dl', { class: 'feedback' });
    if (data.kind === 'SyntaxError') {
      field(list, t('fbProblem'), t('kindSyntax'));
      field(list, t('fbLine'), data.line);
      field(list, t('fbError'), data.message);
    } else if (data.kind === 'ScriptError') {
      field(list, t('fbProblem'), t('kindScript'));
      field(list, t('fbLine'), data.line > 0 ? data.line : '');
      field(list, t('fbError'), data.message);
    } else if (data.kind === 'Timeout') {
      field(list, t('fbProblem'), t('kindTimeout'));
    } else if (data.kind === 'EngineError') {
      field(list, t('fbProblem'), t('kindEngine'));
    } else {
      field(list, t('fbTest'), data.testName);
      if (data.expected || data.actual) {
        field(list, t('fbExpected'), data.expected);
        field(list, t('fbActual'), data.actual);
        field(list, t('fbWhy'), data.because);
      } else {
        field(list, t('fbMessage'), data.message);
      }
    }
    if (data.kind !== 'EngineError') { field(list, t('fbConcept'), loc(data.concept)); }
    output.appendChild(list);
  }

  function renderReviewList(showAll) {
    api('review/items' + (showAll ? '?status=draft,reviewed,approved' : '')).then(function (result) {
      if (!result.ok) { return page([message('bad', t('forbidden'))]); }
      var select = el('select', { style: 'width:auto', onchange: function () { renderReviewList(select.value === 'all'); } }, [
        el('option', { value: 'pending', text: t('reviewPending') }),
        el('option', { value: 'all', text: t('reviewAll'), selected: showAll })
      ]);
      var rows = result.data.items.map(function (item) {
        return el('tr', {}, [
          el('td', {}, [el('a', { href: '#/review/' + item.id, text: item.id })]),
          el('td', {}, [loc(item.title), item.placeholder ? el('span', { class: 'badge warn', text: t('placeholder') }) : null]),
          el('td', { text: t('type_' + item.type) }),
          el('td', {}, [statusBadge(item.status)]),
          el('td', { text: item.review ? item.review.reviewer : '' }),
          el('td', { text: item.review ? formatDate(item.review.timestamp) : '' }),
          el('td', { text: item.review ? item.review.comment : '' })
        ]);
      });
      page([
        el('div', { class: 'row' }, [el('h1', { text: t('reviewTitle') }), el('span', { class: 'spacer' }), el('span', { class: 'muted', text: t('reviewFilter') }), select]),
        rows.length ? el('div', { class: 'card table-wrap' }, [el('table', {}, [
          el('thead', {}, [el('tr', {}, ['colId', 'colTitle', 'colType', 'colStatus', 'colReviewer', 'colWhen', 'colComment'].map(function (key) { return el('th', { text: t(key) }); }))]),
          el('tbody', {}, rows)
        ])]) : message('info', t('reviewEmpty'))
      ]);
    });
  }

  function statusBadge(status) {
    var kind = status === 'approved' ? 'good' : status === 'reviewed' ? 'accent' : 'warn';
    return el('span', { class: 'badge ' + kind, text: t('status_' + status) });
  }

  function pair(labelLeft, left, labelRight, right) {
    return el('div', { class: 'columns section-gap' }, [
      el('div', { class: 'card' }, [el('p', { class: 'column-label', text: labelLeft }), left]),
      el('div', { class: 'card' }, [el('p', { class: 'column-label', text: labelRight }), right])
    ]);
  }

  function renderReviewItem(id, notice) {
    api('review/items/' + encodeURIComponent(id)).then(function (result) {
      if (!result.ok) { return page([message('warn', t('notFound')), el('a', { href: '#/review', text: t('reviewBack') })]); }
      var item = result.data;
      var comment = el('textarea', { id: 'review-comment' });
      function decide(action) {
        api('review/items/' + item.id + '/' + action, { method: 'POST', body: { comment: comment.value } }).then(function (response) {
          if (response.ok) { return renderReviewItem(id, null); }
          var key = { comment_required: 'reviewNeedComment', same_reviewer: 'reviewSame', already_approved: 'reviewAlready' }[response.data.error] || 'errorGeneric';
          renderReviewItem(id, t(key));
        });
      }
      function hintList(list) {
        return el('ol', {}, list.map(function (hint) { return el('li', { text: hint }); }));
      }
      function quizBlock(language) {
        return el('div', {}, item.questions.map(function (question) {
          return el('div', { class: 'question' }, [el('p', { text: question.id + '. ' + question.text[language] })].concat(
            question.options[language].map(function (option, index) {
              var letter = 'abcdefgh'.charAt(index);
              return el('div', { text: (letter === question.answer ? '✓ ' : '   ') + letter + ') ' + option });
            })));
        }));
      }
      var history = item.history.length
        ? el('table', {}, [el('tbody', {}, item.history.map(function (entry) {
          return el('tr', {}, [
            el('td', { text: formatDate(entry.timestamp) }),
            el('td', { text: entry.action }),
            el('td', { text: t('status_' + entry.from) + ' → ' + t('status_' + entry.to) }),
            el('td', { text: entry.reviewer }),
            el('td', { text: entry.comment })
          ]);
        }))])
        : el('p', { class: 'muted', text: t('reviewNoHistory') });

      var children = [
        el('p', { class: 'small' }, [el('a', { href: '#/review', text: t('reviewBack') })]),
        el('div', { class: 'row' }, [
          el('h1', { text: item.id + '  ' + loc(item.title) }),
          statusBadge(item.status),
          el('span', { class: 'badge', text: t('type_' + item.type) }),
          item.placeholder ? el('span', { class: 'badge warn', text: t('placeholder') }) : null
        ]),
        notice ? message('warn', notice) : null,
        el('div', { class: 'card' }, [
          el('p', { class: 'column-label', text: t('meta') }),
          el('p', { text: 'DE: ' + item.title.de + '  |  ' + item.concept.de }),
          el('p', { text: 'EN: ' + item.title.en + '  |  ' + item.concept.en }),
          el('p', { class: 'muted small', text: item.module + ' / ' + item.order + '   prerequisites: ' + (item.prerequisites.join(', ') || '-') + '   pass mark: ' + item.passMark + (item.minPowerShell ? '   min PowerShell: ' + item.minPowerShell : '') + (item.requires.length ? '   requires: ' + item.requires.join(', ') : '') })
        ]),
        pair(t('lesson') + ' ' + t('german'), el('div', { class: 'prose', html: item.lesson.de }), t('lesson') + ' ' + t('english'), el('div', { class: 'prose', html: item.lesson.en })),
        pair(t('task') + ' ' + t('german'), el('div', { class: 'prose', html: item.task.de }), t('task') + ' ' + t('english'), el('div', { class: 'prose', html: item.task.en })),
        pair(t('hints') + ' ' + t('german'), hintList(item.hints.de), t('hints') + ' ' + t('english'), hintList(item.hints.en)),
        item.questions ? pair(t('quiz') + ' ' + t('german'), quizBlock('de'), t('quiz') + ' ' + t('english'), quizBlock('en')) : null,
        pair(t('solutionFile'), el('pre', { class: 'code', text: item.solution }), t('tests'), el('pre', { class: 'code', text: item.tests })),
        pair(t('starter'), el('pre', { class: 'code', text: item.starter }), t('wrongFile'), el('pre', { class: 'code', text: item.wrong })),
        el('div', { class: 'card section-gap' }, [el('p', { class: 'column-label', text: t('reviewHistory') }), history]),
        el('div', { class: 'card' }, [
          el('p', { class: 'muted small', text: t('reviewNoCheck') }),
          el('label', { for: 'review-comment', text: t('reviewComment') }),
          comment,
          el('div', { class: 'row', style: 'margin-top:12px' }, [
            el('button', { type: 'button', class: 'primary', text: t('reviewApprove'), disabled: item.status === 'approved', onclick: function () { decide('approve'); } }),
            el('button', { type: 'button', class: 'danger', text: t('reviewReject'), onclick: function () { decide('reject'); } })
          ])
        ])
      ];
      page(children);
    });
  }

  function simpleTable(headers, rows) {
    return el('div', { class: 'table-wrap' }, [el('table', {}, [
      el('thead', {}, [el('tr', {}, headers.map(function (header) { return el('th', { class: header.num ? 'num' : '', text: header.text }); }))]),
      el('tbody', {}, rows.map(function (cells) {
        return el('tr', {}, cells.map(function (cell, index) {
          return el('td', { class: headers[index].num ? 'num' : '' }, [cell instanceof Node ? cell : String(cell)]);
        }));
      }))
    ])]);
  }

  function renderTrainer() {
    api('trainer/overview').then(function (result) {
      if (!result.ok) { return page([message('bad', t('forbidden'))]); }
      var data = result.data;
      var learnerRows = data.learners.map(function (learner) {
        return [learner.name, learner.completed + '/' + learner.total, learner.percent + ' %', learner.attempts, learner.hints, learner.solutionsViewed, learner.imported, learner.minutes, formatDate(learner.lastActivity)];
      });
      var moduleRows = data.learners.map(function (learner) {
        return [learner.name].concat(learner.modules.map(function (module) { return module.completed + '/' + module.total; }));
      });
      var hardRows = data.hardest.map(function (item) {
        return [item.id, loc(item.title), t('type_' + item.type), item.learners, item.notCompleted, item.failRate + ' %', item.averageAttempts, item.hints, item.solutionsViewed];
      });
      function number(key) { return { text: t(key), num: true }; }
      page([
        el('h1', { text: t('trainerTitle') }),
        data.learners.length ? null : message('info', t('trainerEmpty')),
        el('div', { class: 'card' }, [
          el('h2', { text: t('trainerLearners') }),
          simpleTable([{ text: t('colLearner') }, number('colDone'), number('colPercent'), number('colAttempts'), number('colHints'), number('colSolutions'), number('colImported'), number('colMinutes'), { text: t('colLast') }], learnerRows),
          el('p', { class: 'muted small', text: t('importedHint') })
        ]),
        el('div', { class: 'card' }, [
          el('h2', { text: t('trainerModules') }),
          simpleTable([{ text: t('colLearner') }].concat(data.modules.map(function (module) { return { text: module.id, num: true }; })), moduleRows),
          el('p', { class: 'muted small', text: data.modules.map(function (module) { return module.id + ' ' + loc(module.title); }).join('   ') })
        ]),
        el('div', { class: 'card' }, [
          el('h2', { text: t('trainerHardest') }),
          simpleTable([{ text: t('colId') }, { text: t('colTitle') }, { text: t('colType') }, number('colLearners'), number('colOpen'), number('colFailRate'), number('colAvgAttempts'), number('colHints'), number('colSolutions')], hardRows)
        ])
      ]);
    });
  }

  function renderAdmin(savedNotice) {
    Promise.all([api('admin/execution'), api('admin/users'), api('admin/audit')]).then(function (results) {
      if (!results[0].ok) { return page([message('bad', t('forbidden'))]); }
      var execution = results[0].data;
      var allow = el('textarea', { id: 'allow-list', disabled: execution.locked });
      allow.value = execution.allowList.join('\n');
      var radios = ['Off', 'Pilot', 'On'].map(function (mode) {
        return el('label', { style: 'font-weight:400' }, [
          el('input', { type: 'radio', name: 'mode', value: mode, checked: execution.mode === mode, disabled: execution.locked }),
          ' ' + t('mode' + mode)
        ]);
      });
      var form = el('form', {
        onsubmit: function (event) {
          event.preventDefault();
          var mode = form.querySelector('input[name="mode"]:checked').value;
          var names = allow.value.split(/\r?\n/).map(function (name) { return name.trim(); }).filter(function (name) { return name; });
          api('admin/execution', { method: 'POST', body: { mode: mode, allowList: names } }).then(function (response) {
            if (!response.ok) { return renderAdmin({ kind: 'bad', text: response.data.error === 'locked' ? t('adminLocked') : t('loginInvalid') }); }
            api('me').then(function (me) { state.me = me.data; renderAdmin({ kind: 'good', text: t('adminSaved') }); });
          });
        }
      }, [
        el('label', { text: t('adminMode') })
      ].concat(radios, [
        el('label', { for: 'allow-list', text: t('adminAllow') }),
        allow,
        el('div', { class: 'row', style: 'margin-top:12px' }, [el('button', { type: 'submit', class: 'primary', text: t('adminSave'), disabled: execution.locked })])
      ]));

      var userRows = results[1].data.users.map(function (user) {
        var select = el('select', { style: 'width:auto' }, ['learner', 'reviewer', 'trainer', 'admin'].map(function (role) {
          return el('option', { value: role, text: t('role_' + role), selected: user.role === role });
        }));
        select.addEventListener('change', function () {
          api('admin/users/' + encodeURIComponent(user.name) + '/role', { method: 'POST', body: { role: select.value } }).then(function () { renderAdmin(null); });
        });
        return [user.name, select, formatDate(user.createdAt)];
      });
      var auditRows = results[2].data.entries.map(function (entry) {
        return [formatDate(entry.timestamp), entry.user, entry.action, entry.detail];
      });

      page([
        el('h1', { text: t('adminTitle') }),
        el('div', { class: 'card' }, [
          el('h2', { text: t('adminExecution') }),
          savedNotice ? message(savedNotice.kind, savedNotice.text) : null,
          execution.locked ? message('warn', t('adminLocked')) : null,
          !execution.runnerConfigured ? message('info', t('adminRunnerMissing')) : null,
          form
        ]),
        el('div', { class: 'card' }, [el('h2', { text: t('adminUsers') }), simpleTable([{ text: t('colName') }, { text: t('colRole') }, { text: t('colCreated') }], userRows)]),
        el('div', { class: 'card' }, [el('h2', { text: t('adminAudit') }), simpleTable([{ text: t('colWhen') }, { text: t('colUser') }, { text: t('colAction') }, { text: t('colDetail') }], auditRows)])
      ]);
    });
  }

  function route() {
    renderChrome();
    if (!state.me || !state.me.authenticated) { return renderLogin(null); }
    var hash = window.location.hash || '#/';
    var parts = hash.replace(/^#\//, '').split('/');
    if (parts[0] === 'exercise' && parts[1]) { return renderExercise(parts[1]); }
    if (parts[0] === 'review' && parts[1]) { return renderReviewItem(parts[1], null); }
    if (parts[0] === 'review') { return renderReviewList(false); }
    if (parts[0] === 'trainer') { return renderTrainer(); }
    if (parts[0] === 'admin') { return renderAdmin(null); }
    return renderMap();
  }

  function start() {
    api('me').then(function (result) {
      state.me = result.data;
      route();
    });
  }

  document.getElementById('lang-de').addEventListener('click', function () { setLanguage('de'); route(); });
  document.getElementById('lang-en').addEventListener('click', function () { setLanguage('en'); route(); });
  window.addEventListener('hashchange', route);

  setLanguage(readStore('psdojo.lang') || ((navigator.language || 'en').toLowerCase().indexOf('de') === 0 ? 'de' : 'en'));
  start();
})();
