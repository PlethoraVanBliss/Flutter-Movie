import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class FliterComponent extends Component<FliterState> {
  FliterComponent()
      : super(
          shouldUpdate: (oldState, newState) {
            return oldState.animationController !=
                    newState.animationController ||
                oldState.isToday != newState.isToday ||
                oldState.mediaTypes != newState.mediaTypes ||
                oldState.mediaTypes != newState.mediaTypes;
          },
          clearOnDependenciesChanged: true,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<FliterState>(
              adapter: null, slots: <String, Dependent<FliterState>>{}),
        );
}
