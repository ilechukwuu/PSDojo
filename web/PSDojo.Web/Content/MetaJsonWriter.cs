using System.Globalization;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;

namespace PSDojo.Web.Content;

/// <summary>
/// Writes meta.json in the same layout as the PowerShell module: fixed key order, two spaces
/// of indentation, arrays of plain values on one line. Both front ends produce identical files.
/// </summary>
public static class MetaJsonWriter
{
    private static readonly string[] KeyOrder =
    [
        "id", "module", "title", "type", "order", "prerequisites", "status", "concept", "passMark",
        "minPowerShell", "requires", "placeholder", "review", "reviewHistory", "de", "en",
        "action", "from", "to", "reviewer", "timestamp", "comment",
    ];

    public static string Write(JsonNode? node)
    {
        var builder = new StringBuilder();
        WriteNode(builder, node, 0);
        builder.Append('\n');
        return builder.ToString();
    }

    private static void WriteNode(StringBuilder builder, JsonNode? node, int depth)
    {
        var indent = new string(' ', depth * 2);
        var inner = new string(' ', (depth + 1) * 2);
        switch (node)
        {
            case null:
                builder.Append("null");
                break;
            case JsonObject obj:
                if (obj.Count == 0)
                {
                    builder.Append("{}");
                    break;
                }
                var keys = new List<string>();
                foreach (var key in KeyOrder)
                {
                    if (obj.ContainsKey(key))
                    {
                        keys.Add(key);
                    }
                }
                foreach (var key in obj.Select(pair => pair.Key).OrderBy(key => key, StringComparer.Ordinal))
                {
                    if (!keys.Contains(key))
                    {
                        keys.Add(key);
                    }
                }
                builder.Append("{\n");
                for (var index = 0; index < keys.Count; index++)
                {
                    builder.Append(inner);
                    WriteString(builder, keys[index]);
                    builder.Append(": ");
                    WriteNode(builder, obj[keys[index]], depth + 1);
                    builder.Append(index < keys.Count - 1 ? ",\n" : "\n");
                }
                builder.Append(indent).Append('}');
                break;
            case JsonArray array:
                if (array.Count == 0)
                {
                    builder.Append("[]");
                    break;
                }
                var simple = array.All(item => item is JsonValue);
                if (simple)
                {
                    builder.Append('[');
                    for (var index = 0; index < array.Count; index++)
                    {
                        WriteNode(builder, array[index], depth + 1);
                        if (index < array.Count - 1)
                        {
                            builder.Append(", ");
                        }
                    }
                    builder.Append(']');
                    break;
                }
                builder.Append("[\n");
                for (var index = 0; index < array.Count; index++)
                {
                    builder.Append(inner);
                    WriteNode(builder, array[index], depth + 1);
                    builder.Append(index < array.Count - 1 ? ",\n" : "\n");
                }
                builder.Append(indent).Append(']');
                break;
            case JsonValue value:
                WriteValue(builder, value);
                break;
        }
    }

    private static void WriteValue(StringBuilder builder, JsonValue value)
    {
        var element = value.GetValue<JsonElement>();
        switch (element.ValueKind)
        {
            case JsonValueKind.String:
                WriteString(builder, element.GetString() ?? "");
                break;
            case JsonValueKind.True:
                builder.Append("true");
                break;
            case JsonValueKind.False:
                builder.Append("false");
                break;
            case JsonValueKind.Null:
                builder.Append("null");
                break;
            default:
                builder.Append(element.GetRawText());
                break;
        }
    }

    private static void WriteString(StringBuilder builder, string text)
    {
        builder.Append('"');
        foreach (var character in text)
        {
            switch (character)
            {
                case '"':
                    builder.Append("\\\"");
                    break;
                case '\\':
                    builder.Append("\\\\");
                    break;
                case '\n':
                    builder.Append("\\n");
                    break;
                case '\r':
                    builder.Append("\\r");
                    break;
                case '\t':
                    builder.Append("\\t");
                    break;
                default:
                    if (character < 32)
                    {
                        builder.Append("\\u").Append(((int)character).ToString("x4", CultureInfo.InvariantCulture));
                    }
                    else
                    {
                        builder.Append(character);
                    }
                    break;
            }
        }
        builder.Append('"');
    }
}
