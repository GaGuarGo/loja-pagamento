import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_order.dart';

class CancelOrderDialog extends StatefulWidget {
  const CancelOrderDialog(this.order);

  final UserOrder order;

  @override
  State<CancelOrderDialog> createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends State<CancelOrderDialog> {
  bool loading = false;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) => Future.value(false),
      child: AlertDialog(
        title: Text('Cancelar ${widget.order.formattedId}?'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(loading
                ? 'Cancelando Pedido...'
                : 'Esta ação não poderá ser defeita!'),
            if (error.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  error,
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              )
            ]
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: loading
                ? null
                : () {
                    Navigator.of(context).pop();
                  },
            child: const Text(
              'Voltar',
            ),
          ),
          TextButton(
            onPressed: loading
                ? null
                : () async {
                    setState(() {
                      loading = true;
                    });

                    try {
                      await widget.order.cancel();
                      Navigator.of(context).pop();
                    } catch (e) {
                      setState(() {
                        loading = false;
                        error = e.toString();
                      });
                    }
                  },
            child: const Text(
              'Cancelar Pedido',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
