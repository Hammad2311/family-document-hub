import 'package:flutter/material.dart';

import 'member_management_preview.dart';
import 'document_management_preview.dart';

const _navy = Color(0xFF172B4D);
const _blue = Color(0xFF3157C8);
const _background = Color(0xFFF5F7FB);
const _muted = Color(0xFF68758A);
const _border = Color(0xFFE5EAF2);

const _categories = <String>[
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

const _documents = <_MockDocument>[
  _MockDocument(
    name: 'Aadhaar_Aarav_Sample.pdf',
    member: 'Aarav Sample',
    category: 'Aadhaar',
    size: '1.2 MB',
    icon: Icons.badge_outlined,
  ),
  _MockDocument(
    name: 'Education_Mira_Sample.pdf',
    member: 'Mira Sample',
    category: 'Education',
    size: '860 KB',
    icon: Icons.school_outlined,
  ),
  _MockDocument(
    name: 'Insurance_Dev_Sample.pdf',
    member: 'Dev Sample',
    category: 'Insurance',
    size: '2.4 MB',
    icon: Icons.health_and_safety_outlined,
  ),
];

class AdminDashboardPreview extends StatefulWidget {
  const AdminDashboardPreview({super.key});

  @override
  State<AdminDashboardPreview> createState() => _AdminDashboardPreviewState();
}

class _AdminDashboardPreviewState extends State<AdminDashboardPreview> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedPage = 'Overview';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showSidebar = constraints.maxWidth >= 1050;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: _background,
          drawer: showSidebar
              ? null
              : Drawer(
                  width: 280,
                  child: SafeArea(
                    child: _DashboardSidebar(
                      selectedPage: _selectedPage,
                      onSelect: (page) {
                        setState(() => _selectedPage = page);
                        _scaffoldKey.currentState?.closeDrawer();
                      },
                    ),
                  ),
                ),
          body: SafeArea(
            child: Row(
              children: [
                if (showSidebar)
                  _DashboardSidebar(
                    selectedPage: _selectedPage,
                    onSelect: (page) => setState(() => _selectedPage = page),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      _DashboardHeader(
                        onMenuTap: showSidebar
                            ? null
                            : () => _scaffoldKey.currentState?.openDrawer(),
                      ),
                      Expanded(
                        child: _selectedPage == 'Overview'
                            ? _DashboardContent(showSidebar: showSidebar)
                            : _ManagementPreviewPage(title: _selectedPage),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DashboardSidebar extends StatelessWidget {
  const _DashboardSidebar({required this.selectedPage, required this.onSelect});

  final String selectedPage;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 26, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.folder_shared_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Text(
                  'Family Document Hub',
                  style: TextStyle(
                    color: _navy,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          const Text(
            'WORKSPACE',
            style: TextStyle(
              color: _muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 14),
          _SidebarLabel(
            icon: Icons.dashboard_outlined,
            label: 'Overview',
            selected: selectedPage == 'Overview',
            onTap: () => onSelect('Overview'),
          ),
          _SidebarLabel(
            icon: Icons.people_outline,
            label: 'Members',
            selected: selectedPage == 'Members',
            onTap: () => onSelect('Members'),
          ),
          _SidebarLabel(
            icon: Icons.folder_outlined,
            label: 'Documents',
            selected: selectedPage == 'Documents',
            onTap: () => onSelect('Documents'),
          ),
          _SidebarLabel(
            icon: Icons.category_outlined,
            label: 'Categories',
            selected: selectedPage == 'Categories',
            onTap: () => onSelect('Categories'),
          ),
          _SidebarLabel(
            icon: Icons.storage_outlined,
            label: 'Storage',
            selected: selectedPage == 'Storage',
            onTap: () => onSelect('Storage'),
          ),
          _SidebarLabel(
            icon: Icons.history_outlined,
            label: 'Audit activity',
            selected: selectedPage == 'Audit activity',
            onTap: () => onSelect('Audit activity'),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: _muted, size: 20),
                SizedBox(height: 8),
                Text(
                  'Preview mode',
                  style: TextStyle(color: _navy, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  'Screens use fictional data. Backend actions are not connected.',
                  style: TextStyle(fontSize: 12, color: _muted, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarLabel extends StatelessWidget {
  const _SidebarLabel({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEDF1FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: selected ? _blue : _muted),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? _blue : _muted,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        children: [
          if (onMenuTap != null)
            IconButton(
              tooltip: 'Open navigation menu',
              onPressed: onMenuTap,
              icon: const Icon(Icons.menu, color: _navy),
            ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin dashboard',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Family document management',
                  style: TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5DF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFF4D99C)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.science_outlined,
                  color: Color(0xFF92620A),
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  'MOCK DATA ONLY',
                  style: TextStyle(
                    color: Color(0xFF92620A),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.showSidebar});

  final bool showSidebar;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = constraints.maxWidth < 500 ? 16.0 : 24.0;

        return SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Family overview',
                style: TextStyle(
                  color: _navy,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'A central place to organize your family documents.',
                style: TextStyle(color: _muted, fontSize: 14),
              ),
              const SizedBox(height: 22),
              const _FamilyBanner(),
              const SizedBox(height: 22),
              const _SectionTitle(
                title: 'At a glance',
                subtitle: 'Sample Family',
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, cardConstraints) {
                  final width = cardConstraints.maxWidth;
                  final columns = width >= 900
                      ? 4
                      : width >= 540
                      ? 2
                      : 1;
                  final gap = 14.0;
                  final cardWidth = (width - gap * (columns - 1)) / columns;

                  final cards = [
                    const _MetricCard(
                      icon: Icons.people_outline,
                      label: 'Family members',
                      value: '8 / 10',
                      footnote: '2 places available',
                      color: Color(0xFF3157C8),
                    ),
                    const _MetricCard(
                      icon: Icons.folder_copy_outlined,
                      label: 'Documents',
                      value: '24',
                      footnote: 'Across all members',
                      color: Color(0xFF168269),
                    ),
                    const _MetricCard(
                      icon: Icons.storage_outlined,
                      label: 'Storage used',
                      value: '126 MB',
                      footnote: 'Of 850 MB target',
                      color: Color(0xFF9866C8),
                    ),
                    const _MetricCard(
                      icon: Icons.category_outlined,
                      label: 'Categories',
                      value: '9',
                      footnote: 'Approved V1 categories',
                      color: Color(0xFFD28A26),
                    ),
                  ];

                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (final card in cards)
                        SizedBox(width: cardWidth, child: card),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              const _SectionTitle(
                title: 'Recent documents',
                subtitle: 'Example records only',
              ),
              const SizedBox(height: 12),
              const _DocumentsPanel(),
              const SizedBox(height: 28),
              const _SectionTitle(
                title: 'Document categories',
                subtitle: 'Nine approved categories',
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, categoryConstraints) {
                  final width = categoryConstraints.maxWidth;
                  final columns = width >= 700
                      ? 3
                      : width >= 390
                      ? 2
                      : 1;
                  const gap = 12.0;
                  final tileWidth = (width - gap * (columns - 1)) / columns;

                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (final category in _categories)
                        SizedBox(
                          width: tileWidth,
                          child: _CategoryTile(category: category),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              const Text(
                'All figures and documents on this screen are fictional. '
                'No live Supabase data or document operations are connected.',
                style: TextStyle(color: _muted, fontSize: 12, height: 1.5),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ManagementPreviewPage extends StatelessWidget {
  const _ManagementPreviewPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = constraints.maxWidth < 500 ? 16.0 : 24.0;
        final contentWidth = constraints.maxWidth - padding * 2;

        late final String subtitle;
        late final Widget content;

        switch (title) {
          case 'Members':
            subtitle = 'Sample member records; no real accounts are connected.';
            content = const MemberManagementPreview();
          case 'Documents':
            subtitle = 'Mock PDF uploads and document metadata; no files are sent to Supabase.';
            content = const DocumentManagementPreview();
          case 'Categories':
            subtitle = 'The nine approved V1 document categories.';
            content = _CategoriesPreview(width: contentWidth);
          case 'Storage':
            subtitle = 'Illustrative usage figures; server enforcement is not connected.';
            content = const _StoragePreview();
          case 'Audit activity':
            subtitle =
                'Example events only; no audit-log backend is connected.';
            content = const _PreviewRecordList(
              records: [
                _PreviewRecord(
                  'PDF uploaded',
                  'Aarav Sample · Mock event',
                  Icons.upload_file_outlined,
                ),
                _PreviewRecord(
                  'Member added',
                  'Sample Family · Mock event',
                  Icons.person_add_alt_1_outlined,
                ),
                _PreviewRecord(
                  'Document removed',
                  'Sample record · Mock event',
                  Icons.delete_outline,
                ),
              ],
            );
          default:
            subtitle = 'Preview screen';
            content = const SizedBox.shrink();
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                subtitle,
                style: const TextStyle(color: _muted, fontSize: 14),
              ),
              const SizedBox(height: 20),
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
                        'Preview only — no live backend operations.',
                        style: TextStyle(
                          color: Color(0xFF92620A),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              content,
            ],
          ),
        );
      },
    );
  }
}

class _PreviewRecord {
  const _PreviewRecord(this.title, this.detail, this.icon);

  final String title;
  final String detail;
  final IconData icon;
}

class _PreviewRecordList extends StatelessWidget {
  const _PreviewRecordList({required this.records});

  final List<_PreviewRecord> records;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: records.length,
        separatorBuilder: (_, _) => const Divider(height: 1, color: _border),
        itemBuilder: (context, index) {
          final record = records[index];
          return ListTile(
            leading: Icon(record.icon, color: _blue),
            title: Text(
              record.title,
              style: const TextStyle(color: _navy, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              record.detail,
              style: const TextStyle(color: _muted),
            ),
          );
        },
      ),
    );
  }
}

class _CategoriesPreview extends StatelessWidget {
  const _CategoriesPreview({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final columns = width >= 700
        ? 3
        : width >= 390
        ? 2
        : 1;
    const gap = 12.0;
    final tileWidth = (width - gap * (columns - 1)) / columns;

    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: [
        for (final category in _categories)
          SizedBox(
            width: tileWidth,
            child: _CategoryTile(category: category),
          ),
      ],
    );
  }
}

class _StoragePreview extends StatelessWidget {
  const _StoragePreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quota overview',
            style: TextStyle(
              color: _navy,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '126 MB',
                style: TextStyle(
                  color: _navy,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 8),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  'of 850 MB target',
                  style: TextStyle(color: _muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const LinearProgressIndicator(value: 126 / 850, minHeight: 8),
          const SizedBox(height: 20),
          const Text(
            'Planned warning: around 750 MB. Planned upload hard-stop: '
            'around 900 MB. These are design targets, not enforced limits.',
            style: TextStyle(color: _muted, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _FamilyBanner extends StatelessWidget {
  const _FamilyBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD6E0FF)),
      ),
      child: const Row(
        children: [
          Icon(Icons.shield_outlined, color: _blue, size: 25),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Family workspace',
                  style: TextStyle(
                    color: _navy,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Sample Family · Preview data, not connected to a real account',
                  style: TextStyle(color: _muted, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _navy,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(subtitle, style: const TextStyle(color: _muted, fontSize: 12)),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.footnote,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String footnote;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Text(
            value,
            style: const TextStyle(
              color: _navy,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(footnote, style: const TextStyle(color: _muted, fontSize: 11)),
        ],
      ),
    );
  }
}

class _DocumentsPanel extends StatelessWidget {
  const _DocumentsPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          for (var i = 0; i < _documents.length; i++) ...[
            _DocumentRow(document: _documents[i]),
            if (i < _documents.length - 1)
              const Divider(height: 1, color: _border),
          ],
        ],
      ),
    );
  }
}

class _MockDocument {
  const _MockDocument({
    required this.name,
    required this.member,
    required this.category,
    required this.size,
    required this.icon,
  });

  final String name;
  final String member;
  final String category;
  final String size;
  final IconData icon;
}

class _DocumentRow extends StatelessWidget {
  const _DocumentRow({required this.document});

  final _MockDocument document;

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
            child: Icon(document.icon, color: _blue, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${document.member} · ${document.category}',
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            document.size,
            style: const TextStyle(color: _muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          const Icon(Icons.folder_open_outlined, color: _blue, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              category,
              style: const TextStyle(
                color: _navy,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
