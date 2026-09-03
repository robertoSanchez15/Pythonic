enum FakeDatasetFormat { excel, csv, json }

/// Dataset falso pero con datos reales autorados por nosotros. Alimenta
/// tanto los widgets de "documento falso" como el provisionamiento de
/// archivos reales hacia el sandbox de Piston.
class FakeDataset {
  final String id;
  final String fileName; // ej. "ventas_q3.csv"
  final FakeDatasetFormat format;

  final List<String> columns; // ignorado si format == json
  final List<List<dynamic>> rows; // ignorado si format == json
  final Map<String, dynamic>? jsonContent; // solo si format == json

  const FakeDataset({
    required this.id,
    required this.fileName,
    required this.format,
    this.columns = const [],
    this.rows = const [],
    this.jsonContent,
  });

  String toCsvContent() {
    final buffer = StringBuffer()..writeln(columns.join(','));
    for (final row in rows) {
      buffer.writeln(row.map((v) => v.toString()).join(','));
    }
    return buffer.toString();
  }
}