import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';

class FlavorCubit extends Cubit<FlavorMode> {
  FlavorCubit(this.flavorMode) : super(flavorMode);

  final FlavorMode flavorMode;
}
