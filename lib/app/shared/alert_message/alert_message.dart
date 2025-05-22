import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertMessage {
  static void showStateMessage({
    required BuildContext context,
    required StateMessage stateMessage,
  }) {
    final MessageHandler? messageHandler = stateMessage.messageHandler;
    final String? stringMessage = stateMessage.stringMessage;
    final String? injectedMessage = stateMessage.injectedMessage;

    String? erroDescription;
    String? errorUrl;
    String message = '';

    dynamic data;

    if (messageHandler != null) {
      if (messageHandler is NetworkException) {
        data = messageHandler.data;
        if (data != null && data is String) {
          message = messageHandler.data as String;
        }
      } else if (messageHandler is ResponseMessage) {
        data = messageHandler.data;
        if (messageHandler.message != null) {
          message = messageHandler.getMessage(
            context,
            messageHandler,
            injectedMessage: injectedMessage,
          );
        }
      }
    }

    if (data != null && data is Map) {
      if (data.containsKey('error')) {
        final ResponseString responseString =
            getErrorResponseString(data['error'].toString());
        message =
            ResponseMessage(message: responseString, data: data).getMessage(
          context,
          ResponseMessage(message: responseString),
        );
      }

      if (context.read<ProfileCubit>().state.model.isDeveloperMode) {
        ///error_description
        if (data.containsKey('error_description')) {
          erroDescription = data['error_description'].toString();
        }

        if (erroDescription == null) {
          if (data.containsKey('detail')) {
            erroDescription = data['detail'].toString();
          }
        }

        ///error_uri
        if (data.containsKey('error_uri')) {
          errorUrl = data['error_uri'].toString();
        }
      }
    }

    if (stringMessage != null) {
      if (message.isNotEmpty) {
        message = '$message $stringMessage';
      } else {
        message = stringMessage;
      }
    }

    if (message.isEmpty) {
      message = context.l10n.thisRequestIsNotSupported;
    }

    if (stateMessage.showDialog) {
      showDialog<bool>(
        context: context,
        builder: (context) => ErrorDialog(
          title: message,
          erroDescription: erroDescription,
          erroUrl: errorUrl,
          callToAction: stateMessage.callToAction,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: stateMessage.duration,
          content: SnackBarContent(
            message: message,
            iconPath: stateMessage.type.iconPath,
          ),
          backgroundColor: Colors.transparent,
        ),
      );
    }
  }
}

class SnackBarContent extends StatelessWidget {
  const SnackBarContent({
    super.key,
    required this.message,
    required this.iconPath,
  });

  final String message;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Sizes.space2XSmall,
        horizontal: Sizes.spaceXSmall,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(Sizes.smallRadius),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
            child: Image.asset(
              iconPath,
              width: Sizes.icon,
              height: Sizes.icon,
            ),
          ),
          Expanded(
            child: MyText(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black,
                  ),
              maxLines: 2,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: Text(
              l10n.close.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
