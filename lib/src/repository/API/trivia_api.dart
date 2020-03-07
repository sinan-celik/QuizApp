import 'dart:async';

import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import '../../models/category.dart';
import '../../models/question.dart';

import 'api_interface.dart';

class TriviaAPI implements QuestionsAPI {
  // @override
  // Future<List<Category>> getCategories() async {
  //   const categoriesURL = 'https://opentdb.com/api_category.php';
  //   final response = await http.get(categoriesURL);

  //   if (response.statusCode == 200) {
  //     final jsonResponse = convert.jsonDecode(response.body);
  //     final result = (jsonResponse['trivia_categories'] as List)
  //         .map((category) => Category.fromJson(category));
  //     List<Category> categories;
  //     categories = [];
  //     categories
  //       ..addAll(result)
  //       ..add(Category(id: 0, name: 'Any category'));
  //     //state.rebuild();
  //     return categories;
  //   } else {
  //     print('Request failed with status: ${response.statusCode}.');
  //     //return false;
  //   }
  // }

  @override
  Future<List<Question>> getQuestions(
      { //Rebuilder state,
      List<Question> questions,
      int number,
      Category category,
      QuestionDifficulty difficulty,
      QuestionType type}) async {
    var qdifficulty;
    var qtype;
    switch (difficulty) {
      case QuestionDifficulty.easy:
        qdifficulty = 'easy';
        break;
      case QuestionDifficulty.medium:
        qdifficulty = 'medium';
        break;
      case QuestionDifficulty.hard:
        qdifficulty = 'hard';
        break;
      default:
        qdifficulty = 'medium';
        break;
    }

    switch (type) {
      case QuestionType.boolean:
        qtype = 'boolean';
        break;
      case QuestionType.multiple:
        qtype = 'multiple';
        break;
      default:
        qtype = 'multiple';
        break;
    }

    // final url =
    //     'https://opentdb.com/api.php?amount=$number&difficulty=$qdifficulty&type=$qtype&category=${category.id}';

final url = 'http://10.0.2.2:81/api/Quiz/GetByProjectCode?pCode=test';

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      final result = (jsonResponse['results'] as List)
          .map((question) => QuestionModel.fromJson(question));

      questions = result
          .map((question) => Question.fromQuestionModel(question))
          .toList();      
      return questions;
    } else {
      print('Request failed with status: ${response.statusCode}.');     
    }
  }
}
