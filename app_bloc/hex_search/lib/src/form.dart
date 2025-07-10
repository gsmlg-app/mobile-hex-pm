part of 'bloc.dart';

class HexSearchFormBloc extends FormBloc<String, String> {
  final searchName = TextFieldBloc<String>(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  HexSearchFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        searchName,
      ],
    );
  }

  @override
  void onSubmitting() async {
    try {
      final name = searchName.value;

      emitSuccess(successResponse: name);
    } catch (e) {
      emitFailure(
        failureResponse: e.toString(),
      );
    }
  }
}
