import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/map_provider.dart';
import '../models/salon.dart';

class SearchPanelWidget extends StatelessWidget {
  final Future<void> Function(Salon) onListTileTap;
  const SearchPanelWidget({Key? key, required this.onListTileTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 54,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '검색 결과',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[300]),
          Expanded(
            child: Consumer<MapProvider>(
              builder: (context, provider, _) {
                if (provider.salons.isEmpty) {
                  return Center(child: Text('검색 결과가 없습니다.'));
                }
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.salons.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey[300],
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final salon = provider.salons[index];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          // ListTile 탭 시 onListTileTap 콜백을 호출
                          await onListTileTap(salon);
                        },
                        splashColor: Colors.grey[350]?.withAlpha(128),
                        borderRadius: BorderRadius.circular(12.0),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                            title: Text(
                              salon.title,
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              salon.address,
                              style: theme.textTheme.bodySmall,
                            ),
                            trailing: Text(
                              salon.telephone,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
