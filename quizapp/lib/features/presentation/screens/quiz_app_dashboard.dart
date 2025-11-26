import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp/features/domain/entities/quiz_category_entity.dart';
import 'package:quizapp/features/presentation/helpers/alerts/show_custom_snack_bar.dart';
import 'package:quizapp/features/presentation/helpers/meshBackground.dart';
import 'package:quizapp/features/presentation/provider/categories/categories_bloc.dart';
import 'package:quizapp/features/presentation/provider/categories/categories_event.dart';
import 'package:quizapp/features/presentation/provider/categories/categories_state.dart';
import 'package:quizapp/features/presentation/widgets/bars/build_bottom_navbar.dart';
import 'package:quizapp/features/presentation/widgets/build_more_games_section.dart';
import 'package:quizapp/features/presentation/widgets/cards/daily_task_card.dart';
import 'package:quizapp/features/presentation/widgets/bars/top_bar.dart';
import 'package:quizapp/features/presentation/widgets/quiz_categories.dart'; // AnimatedQuizCategories

class QuizAppDashboard extends StatefulWidget {
  const QuizAppDashboard({super.key});

  @override
  State<QuizAppDashboard> createState() => _QuizAppDashboardState();
}

class _QuizAppDashboardState extends State<QuizAppDashboard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<CategoriesBloc>();
    if (bloc.state != CategoriesLoadedState) {
      bloc.add(const GetCategoriesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: MeshGradientBackground(
        child: BlocConsumer<CategoriesBloc, CategoriesState>(
          listener: (context, state) {
            if (state is CategoriesFailureState) {
              showSnackbar(
                context,
                'Quiz Fetch Failed: ${state.failure.message}',
                isError: true,
              );
            }
          },
          builder: (context, state) {
            if (state is CategoriesLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategoriesLoadedState) {
              return QuizAppDashboardBody(categories: state.categories);
            }
            return const QuizAppDashboardBody(categories: []);
          },
        ),
      ),
    );
  }
}

class QuizAppDashboardBody extends StatelessWidget {
  final List<QuizCategory> categories;

  const QuizAppDashboardBody({super.key, this.categories = const []});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Top Bar
          buildTopBar(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DailyTaskCard(),
                  // Pass the fetched categories to the UI component
                  AnimatedQuizCategories(categories: categories),
                  buildMoreGamesSection(context),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
