namespace PSDojo.Web.Content;

public sealed record LocalText(string De, string En);

public sealed record ModuleInfo(
    string Id,
    int Part,
    int Order,
    LocalText Title,
    IReadOnlyList<string> Prerequisites,
    string Kind,
    string Track,
    string Path);

public sealed record ReviewEntry(
    string Action,
    string From,
    string To,
    string Reviewer,
    string Timestamp,
    string Comment);

public sealed record QuizQuestion(
    int Id,
    LocalText Text,
    IReadOnlyList<string> OptionsDe,
    IReadOnlyList<string> OptionsEn,
    string Answer);

public sealed record ExerciseInfo(
    string Id,
    string Module,
    int ModuleOrder,
    LocalText Title,
    string Type,
    int Order,
    IReadOnlyList<string> Prerequisites,
    string Status,
    LocalText Concept,
    int PassMark,
    bool Placeholder,
    string MinPowerShell,
    IReadOnlyList<string> Requires,
    ReviewEntry? Review,
    IReadOnlyList<ReviewEntry> History,
    string Path)
{
    public bool IsApproved => Status == "approved";
    public bool LocalOnly => Requires.Count > 0;
}

public sealed record ContentSnapshot(
    IReadOnlyList<ModuleInfo> Modules,
    IReadOnlyList<ExerciseInfo> Exercises);
