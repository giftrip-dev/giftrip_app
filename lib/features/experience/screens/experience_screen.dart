import 'package:flutter/material.dart';
import 'package:myong/core/widgets/app_bar/search_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:myong/core/constants/app_colors.dart';
import 'package:myong/features/experience/view_models/experience_view_model.dart';
import 'package:myong/features/experience/widgets/experience_item_list.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  _ExperienceScreenState createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(title: '체험'),
      body: Consumer<ExperienceViewModel>(
        builder: (context, vm, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await vm.fetchExperienceList(refresh: true);
            },
            color: AppColors.primary,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Column(
              children: [
                // 1) 체험 상품 그리드
                Expanded(
                  child: vm.experienceList.isEmpty && vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ExperienceItemList(
                          experiences: vm.experienceList,
                          isLoading: vm.isLoading,
                          onLoadMore: vm.nextPage != null
                              ? () => vm.fetchExperienceList()
                              : null,
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // 초기 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<ExperienceViewModel>();
      if (vm.experienceList.isEmpty) {
        vm.fetchExperienceList();
      }
    });
  }
}
