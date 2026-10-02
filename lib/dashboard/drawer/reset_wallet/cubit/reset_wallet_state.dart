part of 'reset_wallet_cubit.dart';

@JsonSerializable()
class ResetWalletState extends Equatable {
  const ResetWalletState({
    this.isRecoveryPhraseWritten = false,
    this.isBackupCredentialSaved = false,
  });

  factory ResetWalletState.fromJson(Map<String, dynamic> json) =>
      _$ResetWalletStateFromJson(json);

  final bool isRecoveryPhraseWritten;
  final bool isBackupCredentialSaved;

  Map<String, dynamic> toJson() => _$ResetWalletStateToJson(this);

  ResetWalletState copyWith({
    bool? isRecoveryPhraseWritten,
    bool? isBackupCredentialSaved,
  }) {
    final updatedState = ResetWalletState(
      isBackupCredentialSaved:
          isBackupCredentialSaved ?? this.isBackupCredentialSaved,
      isRecoveryPhraseWritten:
          isRecoveryPhraseWritten ?? this.isRecoveryPhraseWritten,
    );
    return updatedState;
  }

  @override
  List<Object?> get props => [isBackupCredentialSaved, isRecoveryPhraseWritten];
}
