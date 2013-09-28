$(document).ready(function() {
	$('#question_question').keyup(function() {
		var question_length = 150-($(this).val().length);
		var count_class = "positive-count"
		if (question_length < 0) {
			var count_class = "negative-count"
		}
		else {
			var count_class = "positive-count"
		}
		$('#question-count').html(question_length).removeClass().addClass(count_class);
	});
	$('#question_correct_answer').keyup(function() {
		var answer_length = 150-($(this).val().length);
		var count_class = "positive-count"
		if (answer_length < 0) {
			var count_class = "negative-count"
		}
		else {
			var count_class = "positive-count"
		}
		$('#answer-count').html(answer_length).removeClass().addClass(count_class);
	});
});