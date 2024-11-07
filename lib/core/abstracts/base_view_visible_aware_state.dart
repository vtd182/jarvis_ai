import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:suga_core/src/ui/base_view_model.dart';
import 'package:visibility_aware_state/visibility_aware_state.dart';

abstract class BaseViewVisibleAwareState<T extends StatefulWidget, M extends BaseViewModel> extends VisibilityAwareState<T> with AfterLayoutMixin<T> {
  late M _viewModel;

  M get viewModel => _viewModel;

  @protected
  void loadArguments() {}

  @protected
  M createViewModel();

  @override
  void initState() {
    _viewModel = createViewModel();
    super.initState();
    loadArguments();
    _viewModel.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _viewModel.afterFirstLayout();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadArguments();
  }

  @override
  void dispose() {
    _viewModel.disposeState();
    super.dispose();
  }
}
