import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tosspayments_widget_sdk_flutter/payment_widget.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/payment_method.dart';
import 'package:tosspayments_widget_sdk_flutter/widgets/agreement.dart';
import 'package:tosspayments_widget_sdk_flutter/model/payment_widget_options.dart';
import 'package:giftrip/features/payment/view_models/payment_view_model.dart';

class PaymentMethodSection extends StatefulWidget {
  const PaymentMethodSection({
    super.key,
    required this.paymentWidget,
    required this.methodSelector,
    required this.agreementSelector,
  });

  final PaymentWidget paymentWidget;
  final String methodSelector;
  final String agreementSelector;

  @override
  State<PaymentMethodSection> createState() => _PaymentMethodSectionState();
}

class _PaymentMethodSectionState extends State<PaymentMethodSection> {
  PaymentMethodWidgetControl? _ctrl;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<PaymentViewModel>();
      _render(vm.finalPrice);
    });
  }

  Future<void> _render(int amount) async {
    try {
      _ctrl = await widget.paymentWidget.renderPaymentMethods(
        selector: widget.methodSelector,
        amount: Amount(value: amount, currency: Currency.KRW, country: 'KR'),
      );
      await widget.paymentWidget.renderAgreement(
        selector: widget.agreementSelector,
      );
      if (mounted) setState(() => _loading = false);
    } catch (_) {
      // selector not found → 200 ms 뒤 재시도
      Future.delayed(const Duration(milliseconds: 200), () => _render(amount));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: PaymentMethodWidget(
            paymentWidget: widget.paymentWidget,
            selector: widget.methodSelector,
          ),
        ),
        SizedBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              AgreementWidget(
                paymentWidget: widget.paymentWidget,
                selector: widget.agreementSelector,
              ),
              if (_loading) const CircularProgressIndicator(),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> updateAmount(int amount) async =>
      _ctrl?.updateAmount(amount: amount);
}
