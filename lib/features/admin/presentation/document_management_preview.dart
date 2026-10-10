import 'package:flutter/material.dart';

const _docNavy = Color(0xFF172B4D);
const _docBlue = Color(0xFF3157C8);
const _docMuted = Color(0xFF68758A);
const _docBorder = Color(0xFFE5EAF2);
const _maxPdfBytes = 10 * 1024 * 1024;

const _sampleMembers = <String>[
  'Aarav Sample',
  'Mira Sample',
  'Dev Sample',
  'Nila Sample',
  'Kiran Sample',
  'Leela Sample',
  'Ravi Sample',
  'Tara Sample',
];

const _documentCategories = <String>[
  'Aadhaar',
  'PAN',
  'Voter ID',
  'Passport',
  'Driving Licence',
  'Insurance',
  'Medical',
  'Education',
  'Other',
];

class DocumentManagementPreview extends StatefulWidget {
  const DocumentManagementPreview({super.key});

  @override
  State<DocumentManagementPreview> createState() =>
      _DocumentManagementPreviewState();
}

class _DocumentManagementPreviewState extends State<DocumentManagementPreview> {
  final List<_PreviewDocument> _documents = [
    const _PreviewDocument(
      name: 'Aadhaar_Aarav_Sample.pdf',
      member: 'Aarav Sample',
      category: 'Aadhaar',
      sizeBytes: 1258291,
    ),
    const _PreviewDocument(
      name: 'Education_Mira_Sample.pdf',
      member: 'Mira Sample',
      category: 'Education',
      sizeBytes: 860 * 1024,
    ),
    const _PreviewDocument(
      name: 'Insurance_Dev_Sample.pdf',
      member: 'Dev Sample',
      category: 'Insurance',
      sizeBytes: 2516582,
    ),
  ];

  int get _totalBytes =>
      _documents.fold(0, (total, document) => total + document.sizeBytes);

  Future<void> _showUploadDialog() async {
    final draft = await showDialog<_UploadDraft>(
      context: context,
      builder: (_) => const _MockPdfUploadDialog(),
    );

    if (!mounted || draft == null) return;

    setState(() {
      _documents.insert(
        0,
        _PreviewDocument(
          name: draft.fileName,
          member: draft.member,
          category: draft.category,
          sizeBytes: (draft.sizeMiB * 1024 * 1024).round(),
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${draft.fileName} added to preview only. No file was uploaded.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            Text(
              '${_documents.length} sample documents',
              style: const TextStyle(
                color: _docNavy,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            FilledButton.icon(
              key: const ValueKey('upload-document-button'),
              onPressed: _showUploadDialog,
              icon: const Icon(Icons.upload_file_outlined, size: 18),
              label: const Text('Upload PDF (preview)'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF5DF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFF4D99C)),
          ),
          child: const Row(
            children: [
              Icon(Icons.science_outlined, color: Color(0xFF92620A)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Preview only. No real file is selected or sent to Supabase.',
                  style: TextStyle(
                    color: Color(0xFF92620A),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _docBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Preview storage total',
                style: TextStyle(color: _docMuted, fontSize: 12),
              ),
              const SizedBox(height: 5),
              Text(
                _formatBytes(_totalBytes),
                style: const TextStyle(
                  color: _docNavy,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _docBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              for (var i = 0; i < _documents.length; i++) ...[
                _PreviewDocumentRow(document: _documents[i]),
                if (i < _documents.length - 1)
                  const Divider(height: 1, color: _docBorder),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'The 10 MiB per-file limit is validated in this preview only. '
          'The backend must enforce the same rule for real uploads.',
          style: TextStyle(color: _docMuted, fontSize: 12, height: 1.5),
        ),
      ],
    );
  }
}

class _PreviewDocument {
  const _PreviewDocument({
    required this.name,
    required this.member,
    required this.category,
    required this.sizeBytes,
  });

  final String name;
  final String member;
  final String category;
  final int sizeBytes;
}

class _PreviewDocumentRow extends StatelessWidget {
  const _PreviewDocumentRow({required this.document});

  final _PreviewDocument document;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF1FF),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.picture_as_pdf_outlined,
              color: _docBlue,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.name,
                  key: ValueKey('document-name-${document.name}'),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _docNavy,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${document.member} · ${document.category}',
                  style: const TextStyle(color: _docMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _formatBytes(document.sizeBytes),
            style: const TextStyle(color: _docMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _UploadDraft {
  const _UploadDraft({
    required this.fileName,
    required this.member,
    required this.category,
    required this.sizeMiB,
  });

  final String fileName;
  final String member;
  final String category;
  final double sizeMiB;
}

class _MockPdfUploadDialog extends StatefulWidget {
  const _MockPdfUploadDialog();

  @override
  State<_MockPdfUploadDialog> createState() => _MockPdfUploadDialogState();
}

class _MockPdfUploadDialogState extends State<_MockPdfUploadDialog> {
  final _formKey = GlobalKey<FormState>();
  final _fileNameController = TextEditingController();
  final _sizeController = TextEditingController(text: '1');
  String _member = _sampleMembers.first;
  String _category = _documentCategories.first;

  @override
  void dispose() {
    _fileNameController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  String? _validateFileName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Enter a PDF filename.';
    if (!name.toLowerCase().endsWith('.pdf')) {
      return 'Filename must end in .pdf.';
    }
    return null;
  }

  String? _validateSize(String? value) {
    final size = double.tryParse(value?.trim() ?? '');
    if (size == null || !size.isFinite || size <= 0) {
      return 'Enter a size greater than 0 MiB.';
    }
    if (size * 1024 * 1024 > _maxPdfBytes) {
      return 'Maximum PDF size is 10 MiB.';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      _UploadDraft(
        fileName: _fileNameController.text.trim(),
        member: _member,
        category: _category,
        sizeMiB: double.parse(_sizeController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Simulate PDF upload'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'This creates a temporary preview record only. No file is uploaded.',
                  style: TextStyle(color: _docMuted, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const ValueKey('upload-file-name'),
                  controller: _fileNameController,
                  decoration: const InputDecoration(
                    labelText: 'PDF filename',
                    hintText: 'Passport_Sample.pdf',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateFileName,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  key: const ValueKey('upload-member-dropdown'),
                  initialValue: _member,
                  decoration: const InputDecoration(
                    labelText: 'Assign to member',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final member in _sampleMembers)
                      DropdownMenuItem(value: member, child: Text(member)),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _member = value);
                  },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  key: const ValueKey('upload-category-dropdown'),
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Document category',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final category in _documentCategories)
                      DropdownMenuItem(value: category, child: Text(category)),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _category = value);
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const ValueKey('upload-size-mib'),
                  controller: _sizeController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'File size (MiB)',
                    helperText:
                        'Must be greater than 0 and no more than 10 MiB.',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateSize,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const ValueKey('confirm-mock-upload'),
          onPressed: _submit,
          child: const Text('Simulate upload'),
        ),
      ],
    );
  }
}

String _formatBytes(int bytes) {
  if (bytes >= 1024 * 1024) {
    final mib = bytes / (1024 * 1024);
    return '${mib.toStringAsFixed(1)} MiB';
  }
  if (bytes >= 1024) return '${(bytes / 1024).round()} KiB';
  return '$bytes bytes';
}
