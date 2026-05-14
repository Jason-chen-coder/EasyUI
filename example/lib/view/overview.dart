import 'package:easy_ui/easy_ui.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = treeItems.where((node) => node.title != '组件总览').toList();
    final theme = EasyTheme.of(context);

    return Scaffold(
      backgroundColor: theme.background,
      body: ListView.separated(
        padding: const EdgeInsets.all(40.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategorySection(context, category);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 48);
        },
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, TreeNode category) {
    if (category.children.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 24,
      children: [
        Row(
          spacing: 12,
          children: [
            Text(
              category.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${category.children.length}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              spacing: 24,
              runSpacing: 24,
              children:
                  category.children.map((node) {
                    return _buildComponentCard(context, node);
                  }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildComponentCard(BuildContext context, TreeNode node) {
    final routeName = node.routeName ?? node.children.firstOrNull?.routeName;

    final assetPath =
        routeName != null
            ? 'assets/overview/${routeName.replaceAll('/', '')}.svg'
            : null;

    Widget buildPlaceholder() {
      return Icon(
        Icons.widgets,
        size: 48,
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      );
    }

    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
          if (node.routeName != null) {
            navigateToRoute(node.routeName!);
          } else if (node.hasChildren && node.children.isNotEmpty) {
            if (node.children.first.routeName != null) {
              navigateToRoute(node.children.first.routeName!);
            }
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 240,
          height: 160,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                node.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  child:
                      assetPath != null
                          ? FutureBuilder(
                            future: DefaultAssetBundle.of(
                              context,
                            ).load(assetPath),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  !snapshot.hasError &&
                                  snapshot.data != null) {
                                return SvgPicture.memory(
                                  snapshot.data!.buffer.asUint8List(),
                                  fit: BoxFit.contain,
                                );
                              }
                              return buildPlaceholder();
                            },
                          )
                          : buildPlaceholder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
