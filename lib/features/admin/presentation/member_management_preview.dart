import 'package:flutter/material.dart';

const _memberNavy = Color(0xFF172B4D);
const _memberBlue = Color(0xFF3157C8);
const _memberMuted = Color(0xFF68758A);
const _memberBorder = Color(0xFFE5EAF2);

class MemberManagementPreview extends StatefulWidget {
  const MemberManagementPreview({super.key});

  @override
  State<MemberManagementPreview> createState() =>
      _MemberManagementPreviewState();
}

class _MemberManagementPreviewState extends State<MemberManagementPreview> {
  final List<_MockMember> _members = [
    const _MockMember(name: 'Aarav Sample', isAdmin: true),
    const _MockMember(name: 'Mira Sample'),
    const _MockMember(name: 'Dev Sample'),
    const _MockMember(name: 'Nila Sample', isActive: false),
    const _MockMember(name: 'Kiran Sample'),
    const _MockMember(name: 'Leela Sample'),
    const _MockMember(name: 'Ravi Sample'),
    const _MockMember(name: 'Tara Sample'),
  ];

  Future<void> _addMember() async {
    if (_members.length >= 10) return;

    final name = await showDialog<String>(
      context: context,
      builder: (_) => _AddMockMemberDialog(
        existingNames: _members.map((member) => member.name).toSet(),
      ),
    );

    if (!mounted || name == null) return;

    setState(() {
      _members.add(_MockMember(name: name));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name added to preview only. No account was created.'),
      ),
    );
  }

  void _toggleMember(_MockMember member) {
    if (member.isAdmin) return;

    setState(() {
      final index = _members.indexWhere((item) => item.name == member.name);
      if (index != -1) {
        _members[index] = member.copyWith(isActive: !member.isActive);
      }
    });
  }

  Future<void> _removeMember(_MockMember member) async {
    if (member.isAdmin) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove sample member?'),
        content: Text(
          'Remove ${member.name} from this preview? '
          'No real account or database record will be changed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      _members.removeWhere((item) => item.name == member.name);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sample member removed from preview.')),
    );
  }

  void _handleAction(String action, _MockMember member) {
    switch (action) {
      case 'toggle':
        _toggleMember(member);
      case 'remove':
        _removeMember(member);
    }
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
          runSpacing: 10,
          children: [
            Text(
              '${_members.length} of 10 members',
              style: const TextStyle(
                color: _memberNavy,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            FilledButton.icon(
              key: const ValueKey('add-member-button'),
              onPressed: _members.length >= 10 ? null : _addMember,
              icon: const Icon(Icons.person_add_alt_1, size: 18),
              label: const Text('Add member'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _memberBorder),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              for (var index = 0; index < _members.length; index++) ...[
                _MemberRow(
                  member: _members[index],
                  onAction: (action) => _handleAction(action, _members[index]),
                ),
                if (index < _members.length - 1)
                  const Divider(height: 1, color: _memberBorder),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'All changes on this screen are temporary and local to this preview. '
          'Member provisioning, account disabling, and removal still require '
          'approved server-side operations.',
          style: TextStyle(color: _memberMuted, fontSize: 12, height: 1.5),
        ),
      ],
    );
  }
}

class _MockMember {
  const _MockMember({
    required this.name,
    this.isAdmin = false,
    this.isActive = true,
  });

  final String name;
  final bool isAdmin;
  final bool isActive;

  _MockMember copyWith({bool? isActive}) {
    return _MockMember(
      name: name,
      isAdmin: isAdmin,
      isActive: isActive ?? this.isActive,
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.member, required this.onAction});

  final _MockMember member;
  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) {
    final role = member.isAdmin ? 'Administrator' : 'Member';
    final status = member.isActive ? 'Active' : 'Disabled';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFEDF1FF),
            child: Text(
              member.name.isEmpty ? '?' : member.name[0].toUpperCase(),
              style: const TextStyle(
                color: _memberBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    color: _memberNavy,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$role · $status',
                  key: ValueKey('member-status-${member.name}'),
                  style: const TextStyle(color: _memberMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          if (!member.isAdmin)
            PopupMenuButton<String>(
              key: ValueKey('member-actions-${member.name}'),
              tooltip: 'Member actions',
              onSelected: onAction,
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'toggle',
                  child: Text(
                    member.isActive ? 'Disable member' : 'Enable member',
                  ),
                ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Text('Remove member'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _AddMockMemberDialog extends StatefulWidget {
  const _AddMockMemberDialog({required this.existingNames});

  final Set<String> existingNames;

  @override
  State<_AddMockMemberDialog> createState() => _AddMockMemberDialogState();
}

class _AddMockMemberDialogState extends State<_AddMockMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add sample member'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This adds a fictional member to this preview only.',
              style: TextStyle(color: _memberMuted, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('new-member-name'),
              controller: _nameController,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Full name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final name = value?.trim() ?? '';

                if (name.isEmpty) {
                  return 'Enter a name.';
                }

                if (widget.existingNames.any(
                  (existing) => existing.toLowerCase() == name.toLowerCase(),
                )) {
                  return 'That sample name already exists.';
                }

                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(context, _nameController.text.trim());
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
