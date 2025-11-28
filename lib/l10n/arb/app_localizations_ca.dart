// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get genericError => 'S’ha produït un error';

  @override
  String get credentialListTitle => 'Credencials';

  @override
  String credentialDetailIssuedBy(Object issuer) {
    return 'Emès per $issuer';
  }

  @override
  String get listActionRefresh => 'Actualitzar';

  @override
  String get listActionViewList => 'Veure com a llista';

  @override
  String get listActionViewGrid => 'Veure com una quadrícula';

  @override
  String get listActionFilter => 'Filtre';

  @override
  String get listActionSort => 'Ordenar';

  @override
  String get onBoardingStartSubtitle => 'Lorem ipsum dolor sit ame';

  @override
  String get onBoardingTosTitle => 'Termes i condicions';

  @override
  String get onBoardingTosText =>
      'En tocar acceptar \"Estic d’acord amb els termes i condicions, així com amb la cessió d’aquesta informació.\"';

  @override
  String get onBoardingTosButton => 'Acceptar';

  @override
  String get onBoardingRecoveryTitle => 'Recuperació de contrasenya';

  @override
  String get onBoardingRecoveryButton => 'Recuperar';

  @override
  String get onBoardingGenPhraseTitle => 'Frase de recuperació';

  @override
  String get onBoardingGenPhraseButton => 'Continuar';

  @override
  String get onBoardingGenTitle => 'Generació de clau privada';

  @override
  String get onBoardingGenButton => 'Generar';

  @override
  String get onBoardingSuccessTitle => 'Identificador creat';

  @override
  String get onBoardingSuccessButton => 'Continuar';

  @override
  String get credentialDetailShare => 'Compartir amb codi QR';

  @override
  String get credentialAddedMessage => 'S’ha afegit una nova credencial!';

  @override
  String get credentialDetailDeleteCard => 'Eliminar la targeta';

  @override
  String get credentialDetailDeleteConfirmationDialog =>
      'Segur que vols eliminar la targeta?';

  @override
  String get credentialDetailDeleteConfirmationDialogYes => 'Sí';

  @override
  String get credentialDetailDeleteConfirmationDialogNo => 'No';

  @override
  String get credentialDetailDeleteSuccessMessage => 'Eliminada correctament.';

  @override
  String get credentialDetailEditConfirmationDialog =>
      'Segur que vols editar la credencial?';

  @override
  String get credentialDetailEditConfirmationDialogYes => 'Guardar';

  @override
  String get credentialDetailEditConfirmationDialogNo => 'Cancel·lar';

  @override
  String get credentialDetailEditSuccessMessage => 'Modificació realitzada.';

  @override
  String get credentialDetailCopyFieldValue =>
      'S\'ha copiat el valor del camp al porta-retalls.';

  @override
  String get credentialDetailStatus => 'Estat de verificació';

  @override
  String get credentialPresentTitle => 'Selecciona credencial/s';

  @override
  String get credentialPresentTitleDIDAuth => 'Sol. autent. DID';

  @override
  String get credentialPresentRequiredCredential => 'Algú demana per les teves';

  @override
  String get credentialPresentConfirm => 'Selecciona credencial/s';

  @override
  String get credentialPresentCancel => 'Refusar';

  @override
  String get selectYourTezosAssociatedWallet =>
      'Selecciona la teva cartera Tezos associada';

  @override
  String get credentialPickSelect => 'Selecciona la teva credencial';

  @override
  String get siopV2credentialPickSelect =>
      'Tria una sola credencial de la teva cartera per presentar-la';

  @override
  String get credentialPickAlertMessage =>
      'Vols donar un àlies a aquesta credencial?';

  @override
  String get credentialReceiveTitle => 'Oferta de credencial';

  @override
  String get credentialReceiveHost => 'vol enviar-te una credencial';

  @override
  String get credentialAddThisCard => 'Afegir aquesta targeta';

  @override
  String get credentialReceiveCancel => 'Anul·lar aquesta targeta';

  @override
  String get credentialDetailListTitle => 'La meva cartera';

  @override
  String get communicationHostAllow => 'Permetre';

  @override
  String get communicationHostDeny => 'Denegar';

  @override
  String get scanTitle => 'Escanejar codi QR';

  @override
  String get scanPromptHost => 'Confies en aquest amfitrió?';

  @override
  String get scanRefuseHost => 'Sol·licitud de comunicació denegada.';

  @override
  String get scanUnsupportedMessage => 'L’URL extreta no és vàlida.';

  @override
  String get qrCodeSharing => 'Estàs compartint';

  @override
  String get qrCodeNoValidMessage => 'El codi QR no conté un missatge vàlid.';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get personalTitle => 'Personal';

  @override
  String get termsTitle => 'Termes i condicions';

  @override
  String get recoveryKeyTitle => 'Frase de recuperació';

  @override
  String get showRecoveryPhrase => 'Mostra frase de recuperació';

  @override
  String get warningDialogTitle => 'Atenció';

  @override
  String get recoveryText => 'Indica la teva frase de recuperació';

  @override
  String get recoveryMnemonicHintText =>
      'Indica aquí la teva frase de recuperació.\nQuan hagis introduït les 12 paraules,\ntoca Importar.';

  @override
  String get recoveryMnemonicError => 'Indica una frase de recordatori vàlida';

  @override
  String get showDialogYes => 'Continuar';

  @override
  String get showDialogNo => 'Cancel·lar';

  @override
  String get supportTitle => 'Ajuda';

  @override
  String get noticesTitle => 'Avisos';

  @override
  String get resetWalletButton => 'Reiniciar cartera';

  @override
  String get resetWalletConfirmationText =>
      'Segur que vols reiniciar la cartera?';

  @override
  String get selectThemeText => 'Seleccionar tema';

  @override
  String get lightThemeText => 'Tema clar';

  @override
  String get darkThemeText => 'Tema fosc';

  @override
  String get systemThemeText => 'Tema del sistema';

  @override
  String get genPhraseInstruction =>
      'Escriu les paraules, descarrega el fitxer de còpia de seguretat i guarda-les en un lloc segur';

  @override
  String get genPhraseExplanation =>
      'Necessites les paraules en l’ordre correcte i el fitxer de còpia de seguretat per recuperar els certificats, si perds l’accés a la cartera';

  @override
  String get errorGeneratingKey =>
      'Error en crear la clau, torna-ho a intentar';

  @override
  String get documentHeaderTooltipName => 'John Doe';

  @override
  String get documentHeaderTooltipJob => 'Comerciant de criptomonedes';

  @override
  String get documentHeaderTooltipLabel => 'Estat:';

  @override
  String get documentHeaderTooltipValue => 'Vàlid';

  @override
  String get didDisplayId => 'DID';

  @override
  String get blockChainDisplayMethod => 'Blockchain';

  @override
  String get blockChainAdress => 'Adreça';

  @override
  String get didDisplayCopy => 'Copiar DID al porta-retalls';

  @override
  String get adressDisplayCopy => 'Copiar adreça al porta-retalls';

  @override
  String get personalSave => 'Guardar';

  @override
  String get personalSubtitle =>
      'La informació del perfil pot servir per completar un certificat quan sigui necessari';

  @override
  String get personalFirstName => 'Nom';

  @override
  String get personalLastName => 'Cognoms';

  @override
  String get personalPhone => 'Telèfon';

  @override
  String get personalAddress => 'Adreça';

  @override
  String get personalMail => 'Correu electrònic';

  @override
  String get lastName => 'Cognoms';

  @override
  String get firstName => 'Nom';

  @override
  String get gender => 'sexe';

  @override
  String get birthdate => 'Data de naixement';

  @override
  String get birthplace => 'Lloc de naixement';

  @override
  String get address => 'Adreça';

  @override
  String get maritalStatus => 'Estat civil';

  @override
  String get nationality => 'Nacionalitat';

  @override
  String get identifier => 'Identificador';

  @override
  String get issuer => 'Emès per';

  @override
  String get workFor => 'Ocupador';

  @override
  String get startDate => 'Des de';

  @override
  String get endDate => 'Fins';

  @override
  String get employmentType => 'Tipus de treball';

  @override
  String get jobTitle => 'Nom del càrrec';

  @override
  String get baseSalary => 'Salari';

  @override
  String get expires => 'Caduca';

  @override
  String get generalInformationLabel => 'Dades generals';

  @override
  String get learningAchievement => 'Assoliments';

  @override
  String get signedBy => 'Firmat per';

  @override
  String get from => 'Des de';

  @override
  String get to => 'Fins';

  @override
  String get credential => 'Credencial';

  @override
  String get issuanceDate => 'Data d’emissió';

  @override
  String get appContactWebsite => 'Lloc web';

  @override
  String get trustFrameworkDescription =>
      'El marc de confiança el formen un conjunt de registres que proporcionen una base segura i fiable perquè les entitats del sistema puguin confiar i interactuar entre elles.';

  @override
  String get confimrDIDAuth => 'Vols iniciar sessió al lloc?';

  @override
  String get evidenceLabel => 'Prova';

  @override
  String get networkErrorBadRequest => 'Petició incorrecta';

  @override
  String get networkErrorConflict => 'Error degut a un conflicte';

  @override
  String get networkErrorPreconditionFailed =>
      'El servidor no compleix una de les precondicions.';

  @override
  String get networkErrorCreated => '';

  @override
  String get networkErrorGatewayTimeout =>
      'Temps d’espera esgotat a la passarel·la';

  @override
  String get networkErrorInternalServerError =>
      'Error intern del servei. Contacta amb l’administrador del servidor';

  @override
  String get networkErrorMethodNotAllowed =>
      'L’usuari no té drets d’accés al contingut';

  @override
  String get networkErrorNoInternetConnection => 'No hi ha connexió a Internet';

  @override
  String get networkErrorNotAcceptable => 'No acceptable';

  @override
  String get networkErrorNotImplemented => 'No aplicat';

  @override
  String get networkErrorOk => '';

  @override
  String get networkErrorRequestCancelled => 'Petició anul·lada';

  @override
  String get networkErrorRequestTimeout => 'Temps d’espera esgotat';

  @override
  String get networkErrorSendTimeout =>
      'Temps d’espera d’enviament en la connexió amb el servidor API';

  @override
  String get networkErrorServiceUnavailable => 'Servei no disponible';

  @override
  String get networkErrorTooManyRequests =>
      'L’usuari ha enviat massa sol·licituds en un període de temps determinat';

  @override
  String get networkErrorUnableToProcess => 'No es poden processar les dades';

  @override
  String get networkErrorUnauthenticated =>
      'L’usuari s’ha d’autenticar per obtenir la resposta sol·licitada';

  @override
  String get networkErrorUnauthorizedRequest => 'Sol·licitud no autoritzada';

  @override
  String get networkErrorUnexpectedError => 'Ha ocorregut un error inesperat';

  @override
  String get networkErrorNotFound => 'No trobat';

  @override
  String get active => 'Actiu';

  @override
  String get expired => 'Expirat';

  @override
  String get revoked => 'Revocat';

  @override
  String get ok => 'OK';

  @override
  String get unavailable_feature_title => 'Funció no disponible';

  @override
  String get unavailable_feature_message => 'Funció no disponible al navegador';

  @override
  String get personalSkip => 'SALTAR';

  @override
  String get restoreCredential => 'Restaurar credencials';

  @override
  String get backupCredential => 'Fer còpia de seguretat de les credencials';

  @override
  String get backupCredentialPhrase =>
      'Escriu les paraules, descarrega el fitxer de còpia de seguretat i guarda-les en un lloc segur';

  @override
  String get backupCredentialPhraseExplanation =>
      'Per fer una còpia de seguretat de les credencials, anota la teva frase de recuperació i guarda-la en un lloc segur.';

  @override
  String get backupCredentialButtonTitle => 'Guardar l’arxiu';

  @override
  String get needStoragePermission =>
      'Et cal un permís d’emmagatzematge per baixar aquest fitxer.';

  @override
  String get backupCredentialNotificationTitle => 'Aconseguit';

  @override
  String get backupCredentialNotificationMessage =>
      'L’arxiu s’ha descarregat amb èxit. Toca per obrir l’arxiu.';

  @override
  String get backupCredentialError =>
      'Ha ocorregut un error. Intenta-ho més tard.';

  @override
  String get backupCredentialSuccessMessage =>
      'L’arxiu s’ha descarregat amb èxit.';

  @override
  String get restorationCredentialWarningDialogSubtitle =>
      'La restauració eliminarà totes les credencials que ja tens a la cartera.';

  @override
  String get recoveryCredentialPhrase =>
      'Escriu les paraules i carrega l’arxiu de seguretat si l’havies guardat';

  @override
  String get recoveryCredentialPhraseExplanation =>
      'Si has perdut les credencials, et calen les dues paraules en l’ordre correcte i una còpia de seguretat xifrada per recuperar-es';

  @override
  String get recoveryCredentialButtonTitle => 'Carregar còpia de seguretat';

  @override
  String recoveryCredentialSuccessMessage(Object postfix) {
    return 'Recuperació correcta$postfix.';
  }

  @override
  String get recoveryCredentialJSONFormatErrorMessage =>
      'Carrega un arxiu vàlid.';

  @override
  String get recoveryCredentialAuthErrorMessage =>
      'El recordatori o l’arxiu carregat estan malmesos.';

  @override
  String get recoveryCredentialDefaultErrorMessage =>
      'Ha ocorregut un error. Intenta-ho més tard.';

  @override
  String get selfIssuedCreatedSuccessfully =>
      'Credencial autoemesa creada correctament';

  @override
  String get companyWebsite => 'Web de l’empresa';

  @override
  String get submit => 'Enviar';

  @override
  String get insertYourDIDKey => 'Indica el DID';

  @override
  String get importYourRSAKeyJsonFile => 'Importa un arxiu json amb clau RSA';

  @override
  String get didKeyAndRSAKeyVerifiedSuccessfully =>
      'DID i clau RSA comprovades';

  @override
  String get pleaseEnterYourDIDKey => 'Indica el teu DID';

  @override
  String get pleaseImportYourRSAKey => 'Importa la teva clau RSA';

  @override
  String get confirm => 'Confirmar';

  @override
  String get pleaseSelectRSAKeyFileWithJsonExtension =>
      'Selecciona el fitxer amb clau RSA (d’extensió json)';

  @override
  String get rsaNotMatchedWithDIDKey => 'La clau RSA no coincideix amb el DID';

  @override
  String get didKeyNotResolved => 'DID no resolt';

  @override
  String get anUnknownErrorHappened => 'Ha ocorregut un error desconegut';

  @override
  String get walletType => 'Tipus de cartera';

  @override
  String get chooseYourWalletType => 'Escull un tipus de cartera';

  @override
  String get proceed => 'Continuar';

  @override
  String get enterpriseWallet => 'Cartera empresarial';

  @override
  String get personalWallet => 'Cartera personal';

  @override
  String get failedToVerifySelfIssuedCredential =>
      'No s’ha pogut verificar la credencial autoemesa';

  @override
  String get failedToCreateSelfIssuedCredential =>
      'No s’ha pogut crear la credencial autoemesa';

  @override
  String get credentialVerificationReturnWarning =>
      'La verificació de credencials ha retornat alguns avisos. ';

  @override
  String get failedToVerifyCredential =>
      'No s’ha pogut verificar la credencial.';

  @override
  String get somethingsWentWrongTryAgainLater =>
      'Hi ha hagut un error, intenta-ho més tard. ';

  @override
  String get successfullyPresentedYourCredential =>
      'Credencials presentades correctament';

  @override
  String get successfullyPresentedYourDID => 'DID presentat correctament';

  @override
  String get thisQRCodeIsNotSupported => 'Codi QR no compatible.';

  @override
  String get thisUrlDoseNotContainAValidMessage =>
      'La URL no conté un missatge vàlid.';

  @override
  String get anErrorOccurredWhileConnectingToTheServer =>
      'Hi ha hagut un error de connexió al servidor.';

  @override
  String get failedToSaveMnemonicPleaseTryAgain =>
      'Error en guardar la clau, torna-ho a intentar';

  @override
  String get failedToLoadProfile => 'Error en carregar el perfil. ';

  @override
  String get failedToSaveProfile => 'Error en guardar el perfil. ';

  @override
  String get failedToLoadDID => 'Error en carregar el DID. ';

  @override
  String get personalOpenIdRestrictionMessage =>
      'La cartera personal no té accés.';

  @override
  String get credentialEmptyError => 'No tens cap credencial a la cartera.';

  @override
  String get credentialPresentTitleSiopV2 => 'Presentar credencial';

  @override
  String get confirmSiopV2 => 'Confirma la credencial presentada';

  @override
  String get storagePermissionRequired => 'Cal un permís d’emmagatzematge';

  @override
  String get storagePermissionDeniedMessage =>
      'Permet l’accés a l’emmagatzematge per carregar el fitxer.';

  @override
  String get storagePermissionPermanentlyDeniedMessage =>
      'Cal permís d’emmagatzematge per carregar el fitxer. Ves a la configuració de l’aplicació i dona accés al permís d’emmagatzematge.';

  @override
  String get cancel => 'Cancel·lar';

  @override
  String get loading => 'Un moment...';

  @override
  String get issuerWebsitesTitle => 'Obtenir credencials';

  @override
  String get getCredentialTitle => 'Obtenir credencials';

  @override
  String get participantCredential => 'Passi GaiaX';

  @override
  String get phonePassCredential => 'Prova de telèfon';

  @override
  String get emailPassCredential => 'Prova de correu electrònic';

  @override
  String get needEmailPass => 'Cal una prova de correu electrònic primer';

  @override
  String get signature => 'Firma';

  @override
  String get proof => 'Prova';

  @override
  String get verifyMe => 'Verifica’m';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get credentialAlias => 'Àlies de credencial';

  @override
  String get verificationStatus => 'Estat de verificació';

  @override
  String get cardsPending => 'Targeta pendent';

  @override
  String get unableToProcessTheData => 'No es poden processar les dades';

  @override
  String get unimplementedQueryType => 'Tipus de consulta no implementat';

  @override
  String get onSubmittedPassBasePopUp => 'Rebràs un correu electrònic';

  @override
  String get myCollection => 'La meva col·lecció';

  @override
  String get items => 'articles';

  @override
  String get succesfullyUpdated => 'Actualitzats correctament';

  @override
  String get generate => 'Generar';

  @override
  String get myAssets => 'Els meus recursos';

  @override
  String get search => 'Buscar';

  @override
  String get professional => 'Professional';

  @override
  String get splashSubtitle => 'Tingues la teva identitat';

  @override
  String get poweredBy => 'Impulsat per';

  @override
  String get splashLoading => 'Carregant...';

  @override
  String get version => 'Versió';

  @override
  String get cards => 'Targetes';

  @override
  String get nfts => 'NFT';

  @override
  String get coins => 'Monedes';

  @override
  String get getCards => 'Obtén credencials';

  @override
  String get close => 'Tancar';

  @override
  String get profile => 'Perfil';

  @override
  String get infos => 'Dades';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Esborrar';

  @override
  String get enterNewPinCode =>
      'Crea un codi PIN\nper protegir la teva cartera';

  @override
  String get confirmYourPinCode => 'Confirma el codi PIN';

  @override
  String get walletAltme => 'Cartera Altme';

  @override
  String get createTitle => 'Crear o importar cartera';

  @override
  String get createSubtitle =>
      'Vols crear una cartera nova o importar-ne una existent?';

  @override
  String get enterYourPinCode => 'Indica el codi PIN';

  @override
  String get changePinCode => 'Canvia el codi PIN';

  @override
  String get tryAgain => 'Torna-ho a intentar';

  @override
  String get credentialSelectionListEmptyError =>
      'No tens la credencial sol·licitada per seguir.';

  @override
  String get trustedIssuer => 'Emissor aprovat per EBSI.';

  @override
  String get yourPinCodeChangedSuccessfully => 'Codi PIN canviat correctament';

  @override
  String get advantagesCards => 'Avantatges de les targetes';

  @override
  String get advantagesDiscoverCards => 'Obtén premis exclusius';

  @override
  String get identityCards => 'Targetes d’identitat';

  @override
  String get identityDiscoverCards => 'Simplifica la verificació ID';

  @override
  String get contactInfoCredentials => 'Informació de contacte';

  @override
  String get contactInfoDiscoverCredentials =>
      'Verifica les teves dades de contacte';

  @override
  String get myProfessionalCards => 'Targetes professionals';

  @override
  String get otherCards => 'Altres targetes';

  @override
  String get inMyWallet => 'A la meva cartera';

  @override
  String get details => 'Detalls';

  @override
  String get getIt => 'Obtenir';

  @override
  String get getItNow => 'Obtenir ara';

  @override
  String get getThisCard => 'Obtenir aquesta carta';

  @override
  String get drawerBiometrics => 'Autenticació biomètrica';

  @override
  String get drawerTalaoCommunityCard => 'Targeta de comunitat Talao';

  @override
  String get drawerTalaoCommunityCardTitle =>
      'Importa la teva direcció d’Ethereum i obtén una targeta de comunitat.';

  @override
  String get drawerTalaoCommunityCardSubtitle =>
      'Tindràs accés als millors descomptes, abonaments i targetes de vals del nostre ecosistema de socis.';

  @override
  String get drawerTalaoCommunityCardTextBoxMessage =>
      'Després d’indicar la teva clau privada, toca Importar.\nAssegura’t d’indicar la clau privada d’Ethereum que conté el teu token Talao.';

  @override
  String get drawerTalaoCommunityCardSubtitle2 =>
      'La nostra cartera és d’autocustòdia. No tenim cap accés a les teves claus o fons privats.';

  @override
  String get drawerTalaoCommunityCardKeyError =>
      'Indica una clau privada vàlida';

  @override
  String get loginWithBiometricsMessage =>
      'Desbloqueja ràpidament la cartera sense contrasenya ni codi PIN';

  @override
  String get manage => 'Gestionar';

  @override
  String get wallet => 'Cartera';

  @override
  String get manageAccounts => 'Gestionar comptes de blockchain';

  @override
  String get blockchainAccounts => 'Comptes de blockchain';

  @override
  String get educationCredentials => 'Credencials de formació';

  @override
  String get educationDiscoverCredentials =>
      'Verifica la teva formació acadèmica';

  @override
  String get educationCredentialsDiscoverSubtitle =>
      'Obtén el teu diploma digital';

  @override
  String get security => 'Seguretat';

  @override
  String get networkAndRegistries => 'Xarxa i registres';

  @override
  String get chooseNetwork => 'Escull xarxa';

  @override
  String get chooseRegistry => 'Escull registre';

  @override
  String get trustFramework => 'Marc de confiança';

  @override
  String get network => 'Xarxa';

  @override
  String get issuerRegistry => 'Registre d’emissors';

  @override
  String get termsOfUse => 'Condicions d’ús i privadesa';

  @override
  String get scanFingerprintToAuthenticate =>
      'Escaneja l’empremta digital per autenticar-te';

  @override
  String get biometricsNotSupported => 'Biomètrica no compatible';

  @override
  String get deviceDoNotSupportBiometricsAuthentication =>
      'El dispositiu no admet l’autenticació biomètrica';

  @override
  String get biometricsEnabledMessage =>
      'Ara pots desbloquejar l’app amb la teva biomètrica.';

  @override
  String get biometricsDisabledMessage => 'S’ha desactivat la teva biomètrica.';

  @override
  String get exportSecretKey => 'Exportar clau secreta';

  @override
  String get secretKey => 'Clau secreta';

  @override
  String get chooseNetWork => 'Escull xarxa';

  @override
  String get nftEmptyMessage => 'La teva galeria digital està buida.';

  @override
  String get myAccount => 'El meu compte';

  @override
  String get cryptoAccounts => 'Comptes';

  @override
  String get cryptoAccount => 'Compte';

  @override
  String get cryptoAddAccount => 'Afegir compte';

  @override
  String get cryptoAddedMessage =>
      'S’ha afegit correctament el teu compte criptogràfic.';

  @override
  String get cryptoEditConfirmationDialog =>
      'Segur que vols editar el nom del compte criptogràfic?';

  @override
  String get cryptoEditConfirmationDialogYes => 'Guardar';

  @override
  String get cryptoEditConfirmationDialogNo => 'Cancel·lar';

  @override
  String get cryptoEditLabel => 'Nom del compte';

  @override
  String get onBoardingFirstTitle =>
      'Descobreix 3 ofertes web exclusives directament a la teva cartera.';

  @override
  String get onBoardingFirstSubtitle =>
      'Aconsegueix targetes de soci, targetes de fidelitat, vals i molts més avantatges de les teves aplicacions i jocs preferits.';

  @override
  String get onBoardingSecondTitle =>
      'La nostra cartera és molt més que una simple cartera digital.';

  @override
  String get onBoardingSecondSubtitle =>
      'Guarda i gestiona les teves dades personals i accedeix a aplicacions web 3.0.';

  @override
  String get onBoardingThirdTitle =>
      'Gestiona les teves dades amb total autonomia, seguretat i privadesa.';

  @override
  String get onBoardingThirdSubtitle =>
      'La nostra cartera utilitza criptografia SSI per a un control total de les teves dades. Res no se’n va del teu telèfon.';

  @override
  String get onBoardingStart => 'Comença';

  @override
  String get learnMoreAboutAltme => 'Informa’t sobre la nostra cartera';

  @override
  String get scroll => 'Desplaça’t';

  @override
  String get agreeTermsAndConditionCheckBox =>
      'Accepto els termes i condicions.';

  @override
  String get readTermsOfUseCheckBox => 'He llegit les condicions d’ús.';

  @override
  String get createOrImportNewAccount => 'Crear o importar un compte nou.';

  @override
  String get selectAccount => 'Seleccionar compte';

  @override
  String get onbordingSeedPhrase => 'Frase llavor';

  @override
  String get onboardingPleaseStoreMessage =>
      'Escriu la teva frase de recuperació';

  @override
  String get onboardingVerifyPhraseMessage =>
      'Confirma paraules de recuperació';

  @override
  String get onboardingVerifyPhraseMessageDetails =>
      'Per assegurar-te que la frase està ben escrita, selecciona les paraules en l\'ordre correcte.';

  @override
  String get onboardingAltmeMessage =>
      'La cartera no és autocustodiada. La frase de recuperació és l’única manera de recuperar el compte.';

  @override
  String get onboardingWroteDownMessage =>
      'He escrit la meva frase de recuperació';

  @override
  String get copyToClipboard => 'Copiar al porta-retalls';

  @override
  String get pinCodeMessage =>
      'El codi PIN impedeix l’accés no autoritzat a la teva cartera. Pots canviar-lo en qualsevol moment.';

  @override
  String get enterNameForYourNewAccount => 'Indica un nou pel teu nou compte';

  @override
  String get create => 'Crear';

  @override
  String get import => 'Importar';

  @override
  String get accountName => 'Nom del compte';

  @override
  String get importWalletText =>
      'Indica aquí la frase de recuperació o la clau privada.';

  @override
  String get importWalletTextRecoveryPhraseOnly =>
      'Indica aquí la teva frase de recuperació.';

  @override
  String get recoveryPhraseDescriptions =>
      'La frase de recuperació (de vegades anomenada frase inicial, clau privada o frase de seguretat) és una llista de 12 paraules creada per la cartera de criptomoneda per accedir als teus fons';

  @override
  String get importEasilyFrom => 'Importa el teu compte des de:';

  @override
  String get templeWallet => 'Cartera Temple';

  @override
  String get temple => 'Temple';

  @override
  String get metaMaskWallet => 'Cartera Metamask';

  @override
  String get metaMask => 'Metamask';

  @override
  String get kukai => 'Kukai';

  @override
  String get kukaiWallet => 'Cartera Kukai';

  @override
  String get other => 'Altres';

  @override
  String get otherWalletApp => 'Altres app de cartera';

  @override
  String importWalletHintText(Object numberCharacters) {
    return 'Quan hagis introduït les 12 paraules (frase de recuperació) o $numberCharacters caràcters (clau privada), toca Importar.';
  }

  @override
  String get importWalletHintTextRecoveryPhraseOnly =>
      'Quan hagis introduït les 12 paraules (frase de recuperació) toca Importar.';

  @override
  String get kycDialogTitle =>
      'Per obtenir aquesta targeta i altres targetes d’identitat, verifica la teva ID';

  @override
  String get idVerificationProcess => 'Procés de verificació ID';

  @override
  String get idCheck => 'Verificació ID';

  @override
  String get facialRecognition => 'Reconeixement facial';

  @override
  String get kycDialogButton => 'Comença la verificació ID';

  @override
  String get kycDialogFooter =>
      'Conforme al RGPD +CCPA + nivell de seguretat SOC2';

  @override
  String get finishedVerificationTitle => 'Verificació ID en\ncurs';

  @override
  String get finishedVerificationDescription =>
      'Rebràs un correu electrònic per confirmar la verificació ID';

  @override
  String get verificationPendingTitle => 'La teva verificació ID\nestà pendent';

  @override
  String get verificationPendingDescription =>
      'La verificació sol requerir menys de 5 min. Rebràs un correu electrònic quan acabi la verificació.';

  @override
  String get verificationDeclinedTitle => 'Verificació rebutjada';

  @override
  String get restartVerification => 'Reiniciar verificació ID';

  @override
  String get verificationDeclinedDescription =>
      'Verificació rebutjada. Reinicia la verificació ID.';

  @override
  String get verifiedTitle => 'Ben fet! Verificació satisfactòria.';

  @override
  String get verifiedDescription =>
      'Ja pots afegir la targeta “majors de 18”. Comencem.';

  @override
  String get verfiedButton => 'Afegir la targeta majors de 18';

  @override
  String get verifiedNotificationTitle => 'Verificació completada!';

  @override
  String get verifiedNotificationDescription =>
      'Felicitats! La verificació s’ha fet correctament.';

  @override
  String get showDecentralizedID => 'Mostra ID descentralitzat';

  @override
  String get manageDecentralizedID => 'Gestiona ID descentralitzat';

  @override
  String get addressBook => 'Llibre d’adreces';

  @override
  String get home => 'La meva cartera';

  @override
  String get discover => 'Descobrir';

  @override
  String get settings => 'Configuració';

  @override
  String get privateKeyDescriptions =>
      'Una clau privada és un número secret per signar transaccions i demostrar la propietat d’una adreça de blockchain. A Tezos, la clau privada sol tenir 54 caràcters.';

  @override
  String get importAccount => 'Importar compte';

  @override
  String get imported => 'Importat';

  @override
  String get cardDetails => 'Detalls de la targeta';

  @override
  String get publicAddress => 'Adreça pública';

  @override
  String get didKey => 'Clau DID';

  @override
  String get export => 'Exportar';

  @override
  String get copy => 'Copiar';

  @override
  String get didPrivateKey => 'Clau privada DID';

  @override
  String get reveal => 'Mostrar';

  @override
  String get didPrivateKeyDescription =>
      'Tingues molta cura amb vostres claus privades: controlen l’accés a la informació de les teves credencials.';

  @override
  String get didPrivateKeyDescriptionAlert =>
      'No les comparteixis amb ningú. Aquesta cartera no és d’autocustòdia,mai t’ho demanarem.';

  @override
  String get iReadTheMessageCorrectly => 'He llegit bé el missatge';

  @override
  String get beCareful => 'Atenció';

  @override
  String get decentralizedIDKey => 'Clau ID descentralitzada';

  @override
  String get copySecretKeyToClipboard =>
      'Clau secreta copiada al porta-retalls.';

  @override
  String get copyDIDKeyToClipboard => 'Clau DID copiada al porta-retalls.';

  @override
  String get seeAddress => 'Veure adreça';

  @override
  String get revealPrivateKey => 'Mostrar clau privada';

  @override
  String get share => 'Compartir';

  @override
  String get shareWith => 'Compartir amb';

  @override
  String get copiedToClipboard => 'Copiada al porta-retalls.';

  @override
  String get privateKey => 'Clau privada';

  @override
  String get decentralizedID => 'IDentificador descentralitzat';

  @override
  String get did => 'DID';

  @override
  String get sameAccountNameError =>
      'Aquest nom de compte s’utilitzava abans; introdueix l’altre nom del compte';

  @override
  String get unknown => 'Desconegut';

  @override
  String get credentialManifestDescription => 'Descripció';

  @override
  String get credentialManifestInformations => 'Dades';

  @override
  String get credentialDetailsActivity => 'Activitat';

  @override
  String get credentialDetailsOrganisation => 'Organització';

  @override
  String get credentialDetailsPresented => 'Presentar';

  @override
  String get credentialDetailsOrganisationDetail => 'Dades de l’organització:';

  @override
  String get credentialDetailsInWalletSince => 'A la cartera des de';

  @override
  String get termsOfUseAndLicenses => 'Condicions d’ús i llicències';

  @override
  String get licenses => 'Llicències';

  @override
  String get sendTo => 'Enviar a';

  @override
  String get next => 'Següent';

  @override
  String get withdrawalInputHint => 'Copiar o escanejar adreça';

  @override
  String get amount => 'Import';

  @override
  String get amountSent => 'Import enviat';

  @override
  String get max => 'Màx';

  @override
  String get edit => 'Editar';

  @override
  String get networkFee => 'Tarifa de gas estimada';

  @override
  String get totalAmount => 'Import total';

  @override
  String get selectToken => 'Seleccionar token';

  @override
  String get insufficientBalance => 'Saldo insuficient';

  @override
  String get slow => 'Lent';

  @override
  String get average => 'Mitjà';

  @override
  String get fast => 'Ràpid';

  @override
  String get changeFee => 'Tarifa de canvi';

  @override
  String get sent => 'Enviat';

  @override
  String get done => 'Fet';

  @override
  String get link => 'Clicar per accedir';

  @override
  String get myTokens => 'Els meus token';

  @override
  String get tezosMainNetwork => 'Xarxa principal de Tezos';

  @override
  String get send => 'Enviar';

  @override
  String get receive => 'Rebre';

  @override
  String get recentTransactions => 'Transaccions recents';

  @override
  String sendOnlyToThisAddressDescription(Object symbol) {
    return 'Enviar només $symbol a aquesta adreça. Enviar altres tokens pot causar pèrdues permanents.';
  }

  @override
  String get addTokens => 'Afegir tokens';

  @override
  String get providedBy => 'Proporcionat per';

  @override
  String get issuedOn => 'Emès el';

  @override
  String get expirationDate => 'Període de validesa';

  @override
  String get connect => 'Connectar';

  @override
  String get connection => 'Connexió';

  @override
  String get selectAccountToGrantAccess =>
      'Seleccionar import per garantir accés:';

  @override
  String get requestPersmissionTo => 'Demanar permís a:';

  @override
  String get viewAccountBalanceAndNFTs => 'Veure saldo del compte i NFT';

  @override
  String get requestApprovalForTransaction =>
      'Demanar autorització per a la transacció';

  @override
  String get connectedWithBeacon => 'Connexió amb dApp';

  @override
  String get failedToConnectWithBeacon => 'Error de connexió amb dApp';

  @override
  String get tezosNetwork => 'Xarxa Tezos';

  @override
  String get confirm_sign => 'Confirmar firma';

  @override
  String get sign => 'Firma';

  @override
  String get payload_to_sign => 'Càrrega per firmar';

  @override
  String get signedPayload => 'Càrrega firmada';

  @override
  String get failedToSignPayload => 'Error en firmar càrrega';

  @override
  String get voucher => 'Cupó';

  @override
  String get tezotopia => 'Tezotopia';

  @override
  String get operationCompleted =>
      'Operació demanada completada. La transacció pot trigar uns minuts a aparèixer a la cartera.';

  @override
  String get operationFailed => 'Error en completar l’operació demanada';

  @override
  String get membership => 'Subscripció';

  @override
  String get switchNetworkMessage => 'Canvia la teva xarxa a';

  @override
  String get fee => 'Tarifa';

  @override
  String get addCards => 'Afegir targetes';

  @override
  String get gaming => 'Jocs';

  @override
  String get identity => 'Identitat';

  @override
  String get payment => 'Pagament';

  @override
  String get socialMedia => 'Xarxes socials';

  @override
  String get advanceSettings => 'Configuració avançada';

  @override
  String get categories => 'Categories';

  @override
  String get selectCredentialCategoryWhichYouWantToShowInCredentialList =>
      'Selecciona les categories de credencials per mostrar a la llista de credencials:';

  @override
  String get community => 'Comunitat';

  @override
  String get tezos => 'Tezos';

  @override
  String get rights => 'Drets';

  @override
  String get disconnectAndRevokeRights => 'Desconnectar i revocar drets';

  @override
  String get revokeAllRights => 'Revocar tots els drets';

  @override
  String get revokeSubtitleMessage => 'Segur que vols revocar tots els drets';

  @override
  String get revokeAll => 'Revocar tots';

  @override
  String get succesfullyDisconnected => 'desconnexió correcta de dApp.';

  @override
  String get connectedApps => 'dApps connectades';

  @override
  String get manageConnectedApps => 'Gestionar dApps connectades';

  @override
  String get noDappConnected => 'Encara no hi ha dApp connectades';

  @override
  String get nftDetails => 'Dades de NFT';

  @override
  String get failedToDoOperation => 'Operació fallida';

  @override
  String get nft => 'NFT';

  @override
  String get receiveNft => 'Rebre NFT';

  @override
  String get sendOnlyNftToThisAddressDescription =>
      'Rebre NFT de Tezos només en aquesta adreça. Enviar NFT d’altres xarxes pot causar pèrdues permanents.';

  @override
  String get beaconShareMessage =>
      'Envia Tezos (XTZ) i NFT de Tezos (estàndard FA2) només a aquesta adreça. Enviar Tezos i NFT d’altres xarxes pot causar pèrdues permanents';

  @override
  String get advantagesCredentialHomeSubtitle =>
      'Gaudeix d’avantatges exclusius a Web3';

  @override
  String get advantagesCredentialDiscoverSubtitle =>
      'Descobreix targetes de fidelitat i passis exclusius';

  @override
  String get identityCredentialHomeSubtitle =>
      'Demostra coses sobre tu mateix protegint les teves dades';

  @override
  String get identityCredentialDiscoverSubtitle =>
      'Obtén credencials de verificació KYC i d’edat reutilitzables';

  @override
  String get myProfessionalCredentialDiscoverSubtitle =>
      'Utilitza les teves targetes professionals amb seguretat';

  @override
  String get blockchainAccountsCredentialHomeSubtitle =>
      'Demostra la propietat dels teus comptes de blockchain';

  @override
  String get educationCredentialHomeSubtitle =>
      'Demostra instantàniament la teva formació acadèmica';

  @override
  String get passCredentialHomeSubtitle =>
      'Utilitza passis exclusius: Potencia l’experiència Web3.';

  @override
  String get financeCardsCredentialHomeSubtitle =>
      'Accedeix a noves oportunitats d’inversió a Web3';

  @override
  String get financeCardsCredentialDiscoverSubtitle =>
      'Obtén avantatges exclusius de les comunitats que t’agraden';

  @override
  String get contactInfoCredentialHomeSubtitle =>
      'Comparteix la teva informació de contacte al moment';

  @override
  String get contactInfoCredentialDiscoverSubtitle =>
      'Obtén credencials fàcils de compartir';

  @override
  String get otherCredentialHomeSubtitle =>
      'Altres tipus de targetes a la teva cartera';

  @override
  String get otherCredentialDiscoverSubtitle =>
      'Altres tipus de targetes que pots afegir';

  @override
  String get showMore => '...Mostrar més';

  @override
  String get showLess => 'Mostrar menys...';

  @override
  String get gotIt => 'Entesos';

  @override
  String get transactionErrorBalanceTooLow =>
      'Una operació ha intentat gastar més tokens del que té el contracte';

  @override
  String get transactionErrorCannotPayStorageFee =>
      'La tarifa d’emmagatzematge és superior al saldo del contracte';

  @override
  String get transactionErrorFeeTooLow =>
      'Les tarifes de transacció són massa baixes';

  @override
  String get transactionErrorFeeTooLowForMempool =>
      'Les tarifes de transacció són massa baixes per a la mempool completa';

  @override
  String get transactionErrorTxRollupBalanceTooLow =>
      'S\'ha intentat gastar un índex de tiquets d’un índex sense el saldo necessari';

  @override
  String get transactionErrorTxRollupInvalidZeroTransfer =>
      'L’import de la transferència ha de ser superior a zero.';

  @override
  String get transactionErrorTxRollupUnknownAddress =>
      'L’adreça ha d’existir en el context en signar una transferència amb ella.';

  @override
  String get transactionErrorInactiveChain =>
      'Intent de validació d’una blockchain inactiva.';

  @override
  String get website => 'Lloc web';

  @override
  String get whyGetThisCard => 'Per què aquesta targeta';

  @override
  String get howToGetIt => 'Com obtenir-la';

  @override
  String get emailPassWhyGetThisCard =>
      'Algunes aplicacions/llocs web de Web 3 poden requerir aquesta prova per accedir al seu servei o obtenir avantatges: Targeta de membre, de fidelitat, premis, etc.';

  @override
  String get emailPassExpirationDate =>
      'Aquesta targeta romandrà activa i reutilitzable durant 1 ANY.';

  @override
  String get emailPassHowToGetIt =>
      'És molt fàcil. Altme verificarà el teu correu electrònic enviant un codi per correu electrònic.';

  @override
  String get tezotopiaMembershipWhyGetThisCard =>
      'Aquesta targeta de membre dona un 25 % de reemborsament en efectiu en TOTES les transaccions del joc Tezotopia en comprar un Drops al mercat o encunyar un NFT a Starbase.';

  @override
  String get tezotopiaMembershipExpirationDate =>
      'Aquesta targeta romandrà activa i reutilitzable durant 1 ANY.';

  @override
  String get tezotopiaMembershipLongDescription =>
      'Tezotopia és un joc NFT metavers en temps real a Tezos, on els jugadors tenen una granja amb Tezotops, participen en batalles per obtenir recompenses i reclamen terra en una aventura espacial immersiva de blockchain. Explora el metavers, col·lecciona NFT i conquereix Tezotopia.';

  @override
  String get chainbornMembershipHowToGetIt =>
      'Per obtenir aquesta targeta, cal invocar un “Heroi” al joc Chainborn i una prova de correu electrònic. Trobaràs la targeta “Prova de correu electrònic” a la secció “Descobrir” d\'Altme.';

  @override
  String get chainbornMembershipWhyGetThisCard =>
      'Sigues dels pocs que tenen accés al contingut exclusiu de la botiga Chainborn, airdrops i altres avantatges reservats als membres!';

  @override
  String get chainbornMembershipExpirationDate =>
      'Aquesta targeta romandrà activa i reutilitzable durant 1 ANY.';

  @override
  String get chainbornMembershipLongDescription =>
      'Chainborn és un emocionant joc de batalla de NFT on els jugadors utilitzen els seus propis NFT com a herois, competint per botí i glòria. Participa en emocionants lluites, guanya punts d’experiència per potenciar la força i la salut del teu heroi, i millora el valor dels teus NFT en aquesta apassionant aventura de Tezos.';

  @override
  String get twitterHowToGetIt =>
      'Segueix els passos a TezosProfiles https://tzprofiles.com/connect. Després, demana la targeta “Compte de Twitter” a Altme. Assegura’t de signar la transacció a TZPROFILES amb el mateix compte que utilitzes a Altme.';

  @override
  String get twitterWhyGetThisCard =>
      'Aquesta targeta és una prova que ets el propietari del teu compte de Twitter. Utilitza-la per demostrar la propietat del teu compte de Twitter sempre que ho necessitis.';

  @override
  String get twitterExpirationDate =>
      'Aquesta targeta romandrà activa durant 1 ANY.';

  @override
  String get twitterDummyDesc =>
      'Demostra la propietat dels teus comptes de Twitter';

  @override
  String get tezotopiaMembershipHowToGetIt =>
      'Has de presentar una prova que tens més de 13 anys i una prova del teu correu electrònic.';

  @override
  String get over18WhyGetThisCard =>
      'Algunes aplicacions/llocs web de Web 3 poden requerir aquesta prova per accedir al seu servei o obtenir avantatges: Targeta de membre, de fidelitat, premis, etc.';

  @override
  String get over18ExpirationDate =>
      'Aquesta targeta romandrà activa i reutilitzable durant 1 ANY.';

  @override
  String get over18HowToGetIt =>
      'Pots demanar aquesta targeta seguint la verificació KYC d’Altme.';

  @override
  String get over13WhyGetThisCard =>
      'Algunes aplicacions/llocs web de Web 3 poden requerir aquesta prova per accedir al seu servei o obtenir avantatges: Targeta de membre, de fidelitat, premis, etc.';

  @override
  String get over13ExpirationDate =>
      'Aquesta targeta romandrà activa i reutilitzable durant 1 ANY.';

  @override
  String get over13HowToGetIt =>
      'Pots demanar aquesta targeta seguint la verificació KYC d’Altme.';

  @override
  String get over15WhyGetThisCard =>
      'Algunes aplicacions/llocs web de Web 3 poden requerir aquesta prova per accedir al seu servei o obtenir avantatges: Targeta de membre, de fidelitat, premis, etc.';

  @override
  String get over15ExpirationDate =>
      'Aquesta targeta romandrà activa i reutilitzable durant 1 ANY.';

  @override
  String get over15HowToGetIt =>
      'Pots demanar aquesta targeta seguint la verificació KYC d’Altme.';

  @override
  String get passportFootprintWhyGetThisCard =>
      'Algunes aplicacions/llocs web de Web 3 poden requerir aquesta prova per accedir al seu servei o obtenir avantatges: Targeta de membre, de fidelitat, premis, etc.';

  @override
  String get passportFootprintExpirationDate =>
      'Aquesta targeta romandrà activa i reutilitzable durant 1 ANY.';

  @override
  String get passportFootprintHowToGetIt =>
      'Pots demanar aquesta targeta seguint la verificació KYC d’Altme.';

  @override
  String get verifiableIdCardWhyGetThisCard =>
      'Aquesta targeta d’identitat digital conté la mateixa informació que la teva targeta d’identitat física. La pots utilitzar al Web 3 per a una verificació KYC, per exemple.';

  @override
  String get verifiableIdCardExpirationDate =>
      'Aquesta targeta romandrà activa i reutilitzable durant 1 ANY.';

  @override
  String get verifiableIdCardHowToGetIt =>
      'Pots demanar aquesta targeta seguint la verificació KYC d’Altme.';

  @override
  String get verifiableIdCardDummyDesc =>
      'Obtén la teva targeta d’identitat digital.';

  @override
  String get phoneProofWhyGetThisCard =>
      'Algunes aplicacions/llocs web de Web 3 poden requerir aquesta prova per accedir al seu servei o obtenir avantatges: Targeta de membre, de fidelitat, premis, etc.';

  @override
  String get phoneProofExpirationDate =>
      'Aquesta targeta romandrà activa i reutilitzable durant 1 ANY.';

  @override
  String get phoneProofHowToGetIt =>
      'És molt fàcil. Altme verificarà el teu número de telèfon enviant un codi per SMS.';

  @override
  String get tezVoucherWhyGetThisCard =>
      'Aquesta targeta cupó dona un 10 % de reemborsament en efectiu en TOTES les transaccions del joc Tezotopia en comprar un Drops al mercat o encunyar un NFT a Starbase.';

  @override
  String get tezVoucherExpirationDate =>
      'Aquesta targeta romandrà activa i reutilitzable durant 30 dies.';

  @override
  String get tezVoucherHowToGetIt => ' És molt fàcil. Demana-la de franc ara.';

  @override
  String get genderWhyGetThisCard =>
      'Aquesta prova de gènere és útil per demostrar el teu gènere (masculí / femení) sense donar cap altra informació teva. Es fa servir en enquestes, etc.';

  @override
  String get genderExpirationDate =>
      'Aquesta targeta romandrà activa i reutilitzable durant 1 ANY.';

  @override
  String get genderHowToGetIt =>
      'Pots demanar aquesta targeta seguint la verificació KYC d’Altme.';

  @override
  String get nationalityWhyGetThisCard =>
      'Aquesta credencial és útil per demostrar la teva nacionalitat sense donar cap altra informació teva. Pot demanar-se en aplicacions Web 3 en enquestes d\'usuari, etc.';

  @override
  String get nationalityExpirationDate =>
      'Aquesta targeta romandrà activa i reutilitzable durant 1 ANY.';

  @override
  String get nationalityHowToGetIt =>
      'Pots demanar aquesta targeta seguint la verificació KYC d’Altme.';

  @override
  String get ageRangeWhyGetThisCard =>
      'Aquesta credencial és útil per demostrar la teva edat sense donar cap altra informació teva. Pot caldre en aplicacions Web 3 per a enquestes d’usuari o per obtenir avantatges: Targeta de membre, etc.';

  @override
  String get ageRangeExpirationDate =>
      'Aquesta targeta romandrà activa i reutilitzable durant 1 ANY.';

  @override
  String get ageRangeHowToGetIt =>
      'Pots demanar aquesta targeta seguint la verificació KYC d’Altme.';

  @override
  String get defiComplianceWhyGetThisCard =>
      'Obtén una prova verificable de conformitat amb KYC/AML, sol·licitada per protocols DeFi compatibles i dApps de Web3. Una vegada obtinguda, pots encunyar un NFT protector de privadesa i no transferible per a la verificació a la cadena de blocs sense mostrar dades personals.';

  @override
  String get defiComplianceExpirationDate =>
      'Aquestes credencials romanen actives 3 mesos. Per renovació cal una comprovació de conformitat senzilla, sense nou KYC.';

  @override
  String get defiComplianceHowToGetIt =>
      'És fàcil! Fes una verificació KYC única a la cartera Altme (desenvolupada per ID360) i sol·demana la teva credencial de conformitat DeFi.';

  @override
  String get origin => 'Origen';

  @override
  String get nftTooBigToLoad => 'NFT massa gran per carregar';

  @override
  String get seeTransaction => 'Veure transacció';

  @override
  String get nftListSubtitle =>
      'Aquí tens tots els NFT i objectes de col·lecció al teu compte.';

  @override
  String get tokenListSubtitle => 'Aquí tens tots els tokens al teu compte.';

  @override
  String get my => 'El meu';

  @override
  String get get => 'Obtenir';

  @override
  String get seeMoreNFTInformationOn => 'Veure més informació de NFT sobre';

  @override
  String get credentialStatus => 'Estat';

  @override
  String get pass => 'Passi';

  @override
  String get payloadFormatErrorMessage => 'Format de càrrega incorrecte.';

  @override
  String get thisFeatureIsNotSupportedMessage =>
      'Aquesta funció encara no s\'admet';

  @override
  String get myWallet => 'La meva cartera';

  @override
  String get ethereumNetwork => 'Xarxa Ethereum';

  @override
  String get fantomNetwork => 'Xarxa Fantom';

  @override
  String get polygonNetwork => 'Xarxa Polygon';

  @override
  String get binanceNetwork => 'Xarxa BNB Chain';

  @override
  String get step => 'Pas';

  @override
  String get activateBiometricsTitle =>
      'Activar biomètrica\nper afegir una capa de seguretat';

  @override
  String get loginWithBiometricsOnBoarding => 'Inciar sessió amb biomètrica';

  @override
  String get option => 'Opció';

  @override
  String get start => 'Comença';

  @override
  String get iAgreeToThe => 'Autoritzo els ';

  @override
  String get termsAndConditions => 'Termes i condicions';

  @override
  String get walletReadyTitle => 'La cartera està a punt!';

  @override
  String get walletReadySubtitle =>
      'Anem a descobrim-ho tot \nWeb 3 té coses per oferir.';

  @override
  String get failedToInitCamera => 'Error d’inici de càmera.';

  @override
  String get chooseMethodPageOver18Title =>
      'Tria un mètode per aconseguir la prova més de 18';

  @override
  String get chooseMethodPageOver13Title =>
      'Tria un mètode per aconseguir la prova més de 13';

  @override
  String get chooseMethodPageOver15Title =>
      'Tria un mètode per aconseguir la prova més de 15';

  @override
  String get chooseMethodPageOver21Title =>
      'Tria un mètode per aconseguir la prova més de 21';

  @override
  String get chooseMethodPageOver50Title =>
      'Tria un mètode per aconseguir la prova més de 50';

  @override
  String get chooseMethodPageOver65Title =>
      'Tria un mètode per aconseguir la prova més de 65';

  @override
  String get chooseMethodPageAgeRangeTitle =>
      'Tria un mètode per aconseguir la prova d’edat';

  @override
  String get chooseMethodPageVerifiableIdTitle =>
      'Tria un mètode per aconseguir la prova d’ID verificable';

  @override
  String get chooseMethodPageDefiComplianceTitle =>
      'Tria un mètode per aconseguir la prova de conformitat amb DeFi';

  @override
  String get chooseMethodPageSubtitle =>
      'Verifica’t amb una foto en temps real o amb una verificació clàssica de documents d’identitat.';

  @override
  String get kycTitle => 'Foto ràpida (1 min)';

  @override
  String get kycSubtitle => 'Verifica’t ràpidament amb una foto teva.';

  @override
  String get passbaseTitle => 'Verificació completa del document d’identitat';

  @override
  String get passbaseSubtitle =>
      'Verifica’t amb un document d’identitat, passaport o carnet de conduir.';

  @override
  String get verifyYourAge => 'Verifica la teva edat';

  @override
  String get verifyYourAgeSubtitle =>
      'El procés de verificació d’edat és molt fàcil i senzill. Només cal és una foto en temps real.';

  @override
  String get verifyYourAgeDescription =>
      'En acceptar, accedeixes a que usem una imatge per calcular la teva edat. El càlcul el fa el nostre soci Yoti, que utilitza la imatge només per a aquest propòsit i l\'elimina immediatament.\n\nPer saber-ne més, consulta la política de privadesa.';

  @override
  String get accept => 'Acceptar';

  @override
  String get decline => 'Rebutjar';

  @override
  String get yotiCameraAppbarTitle => 'Col·loca la cara al centre';

  @override
  String get cameraSubtitle =>
      'Tens 5 segons per fer la foto.\nMira que hi hagi prou llum abans de començar.';

  @override
  String get walletSecurityDescription =>
      'Protegeix la cartera amb el codi PIN i l’autenticació biomètrica';

  @override
  String get blockchainSettings => 'Configuració de blockchain';

  @override
  String get blockchainSettingsDescription =>
      'Administrar comptes, frase de recuperació, dApps connectades i xarxes';

  @override
  String get ssi => 'Identitat Autònoma (DID)';

  @override
  String get ssiDescription =>
      'Administra la ID descentralitzada i fes còpies de seguretat o restaura les teves credencials';

  @override
  String get helpCenter => 'Centre d’assistència';

  @override
  String get helpCenterDescription =>
      'Posa’t en contacte amb nosaltres i t’ajudarem a utilitzar la nostra cartera';

  @override
  String get about => 'Informació';

  @override
  String get aboutDescription =>
      'Llegeix les condicions d’ús, la privadesa i les llicències';

  @override
  String get resetWallet => 'Reiniciar cartera';

  @override
  String get resetWalletDescription =>
      'Esborra totes les dades emmagatzemades al teu telèfon i restableix la cartera.';

  @override
  String get showWalletRecoveryPhrase =>
      'Mostra frase de recuperació de la cartera';

  @override
  String get showWalletRecoveryPhraseSubtitle =>
      'La frase de recuperació actua com una clau de còpia de seguretat per restaurar l\'accés a la cartera';

  @override
  String get blockchainNetwork => 'Xarxa de blockchain (per defecte)';

  @override
  String get contactUs => 'Contacte';

  @override
  String get officialWebsite => 'Lloc web oficial';

  @override
  String get yourAppVersion => 'La teva versió d’app';

  @override
  String get resetWalletTitle => 'Segur que vols reiniciar la cartera?';

  @override
  String get resetWalletSubtitle =>
      'L’acció esborrarà les teves dades. Comprova que has guardat la teva frase de recuperació i la còpia de seguretat de les teves credencials abans d’eliminar-les.';

  @override
  String get resetWalletSubtitle2 =>
      'La cartera és autocustodiada: no podem recuperar els fons o credencials en lloc teu.';

  @override
  String get resetWalletCheckBox1 => 'He escrit la meva frase de recuperació';

  @override
  String get resetWalletCheckBox2 =>
      'He guardat el fitxer de còpia de seguretat de les meves credencials';

  @override
  String get email => 'Correu electrònic';

  @override
  String get fillingThisFieldIsMandatory => 'És obligatori omplir aquest camp.';

  @override
  String get yourMessage => 'El teu missatge';

  @override
  String get message => 'Missatge';

  @override
  String get subject => 'Assumpte';

  @override
  String get enterAValidEmail => 'Indica un correu electrònic vàlid.';

  @override
  String get failedToSendEmail => 'Enviament de correu electrònic fallit.';

  @override
  String get selectAMethodToAddAccount =>
      'Seleccionar un mètode per afegir compte';

  @override
  String get createAccount => 'Crear compte';

  @override
  String get createAccountDescription =>
      'Crear compte protegit per la teva frase de recuperació';

  @override
  String get importAccountDescription =>
      'Importar un compte d’una cartera existent';

  @override
  String get chooseABlockchainForAccountCreation =>
      'Escull la blockchain on vols crear un nou compte.';

  @override
  String get tezosAccount => 'Compte Tezos';

  @override
  String get tezosAccountDescription =>
      'Crear una nova direcció de blockchain de Tezos';

  @override
  String get ethereumAccount => 'Compte Ethereum';

  @override
  String get ethereumAccountDescription =>
      'Crear una nova direcció de blockchain d’Ethereum';

  @override
  String get fantomAccount => 'Compte Fantom';

  @override
  String get fantomAccountDescription =>
      'Crear una nova direcció de blockchain de Fantom';

  @override
  String get polygonAccount => 'Compte Polygon';

  @override
  String get polygonAccountDescription =>
      'Crear una nova direcció de blockchain de Polygon';

  @override
  String get binanceAccount => 'Compte BNB Chain';

  @override
  String get binanceAccountDescription =>
      'Crear una nova direcció de blockchain de BNB Chain';

  @override
  String get setAccountNameDescription =>
      'Vols donar un nom a aquest compte nou? És útil si en tens uns quants.';

  @override
  String get letsGo => 'Som-hi!';

  @override
  String get congratulations => 'Felicitats!';

  @override
  String get tezosAccountCreationCongratulations =>
      'El teu nou compte de Tezos s’ha creat amb èxit.';

  @override
  String get ethereumAccountCreationCongratulations =>
      'El teu nou compte d’Ethereum s’ha creat amb èxit.';

  @override
  String get fantomAccountCreationCongratulations =>
      'El teu nou compte de Fantom s’ha creat amb èxit.';

  @override
  String get polygonAccountCreationCongratulations =>
      'El teu nou compte de Polygon s’ha creat amb èxit.';

  @override
  String get binanceAccountCreationCongratulations =>
      'El teu nou compte de BNB Chain s’ha creat amb èxit.';

  @override
  String get accountImportCongratulations =>
      'El teu compte s’ha importat correctament.';

  @override
  String get saveBackupCredentialTitle =>
      'Descarrega l’arxiu de còpia de seguretat.\nGuarda’l en un lloc segur.';

  @override
  String get saveBackupCredentialSubtitle =>
      'Per recuperar totes les teves credencials, cal la frase de recuperació i aquest arxiu de còpia de seguretat.';

  @override
  String get saveBackupPolygonCredentialSubtitle =>
      'Per recuperar totes les teves credencials ID de Polygon, cal la frase de recuperació i aquest arxiu de còpia de seguretat.';

  @override
  String get restoreCredentialStep1Title =>
      'Pas 1: Indica les 12 paraules de la frase de recuperació';

  @override
  String get restorePhraseTextFieldHint =>
      'Indica la frase de recuperació (o frase de recordatori) aquí...';

  @override
  String get restoreCredentialStep2Title =>
      'Pas 2: Carrega les credencials a l’arxiu de còpia de seguretat';

  @override
  String get loadFile => 'Carregar arxiu';

  @override
  String get uploadFile => 'Pujar arxiu';

  @override
  String get creators => 'Creadors';

  @override
  String get publishers => 'Publicadors';

  @override
  String get creationDate => 'Data de creació';

  @override
  String get myProfessionalrCards => 'targetes professionals';

  @override
  String get myProfessionalrCardsSubtitle =>
      'Utilitza les teves targetes professionals amb seguretat.';

  @override
  String get guardaWallet => 'Cartera Guarda';

  @override
  String get exodusWallet => 'Cartera Exodus';

  @override
  String get trustWallet => 'Cartera Trust';

  @override
  String get myetherwallet => 'Cartera MyEther';

  @override
  String get skip => 'Saltar';

  @override
  String get userNotFitErrorMessage =>
      'No pots obtenir aquesta targeta perquè no es compleixen algunes condicions.';

  @override
  String get youAreMissing => 'Falten';

  @override
  String get credentialsRequestedBy => 'credencials demanades per';

  @override
  String get transactionIsLikelyToFail => 'La transacció probablement fallarà.';

  @override
  String get buy => 'Comprar';

  @override
  String get thisFeatureIsNotSupportedYetForFantom =>
      'Aquesta funció encara no s\'admet a Fantom.';

  @override
  String get faqs => 'Preguntes freqüents';

  @override
  String get softwareLicenses => 'Llicències de software';

  @override
  String get notAValidWalletAddress => 'Adreça de cartera invàlida.';

  @override
  String get otherAccount => 'Altre compte';

  @override
  String get thereIsNoAccountInYourWallet =>
      'No hi ha comptes a la teva cartera';

  @override
  String get credentialSuccessfullyExported =>
      'La teva credencial s’ha exportat correctament.';

  @override
  String get scanAndDisplay => 'Escanejar i mostrar';

  @override
  String get whatsNew => 'Novetats';

  @override
  String get okGotIt => 'Entesos!';

  @override
  String get support => 'ajuda';

  @override
  String get transactionDoneDialogDescription =>
      'Pot trigar uns minuts perquè la transferència es completi';

  @override
  String get withdrawalFailedMessage =>
      'La retirada del compte no ha funcionat';

  @override
  String get credentialRequiredMessage =>
      'Necessites tenir aquestes credencials a la cartera per adquirir aquesta targeta:';

  @override
  String get keyDecentralizedIdEdSA => 'Clau d’ID descentralitzada EdDSA';

  @override
  String get keyDecentralizedIDSecp256k1 =>
      'Clau d’ID descentralitzada Secp256k1';

  @override
  String get ebsiV3DecentralizedId => 'ID descentraltitzada de la v3 d’EBSI';

  @override
  String get requiredCredentialNotFoundTitle =>
      'No hem trobat la credencial\nque et cal a la teva cartera.';

  @override
  String get requiredCredentialNotFoundSubTitle =>
      'La credencial requerida no és a la teva cartera';

  @override
  String get requiredCredentialNotFoundDescription => 'Contacta’ns a:';

  @override
  String get backToHome => 'Tornar a l’inici';

  @override
  String get help => 'Ajuda';

  @override
  String get searchCredentials => 'Buscar credencials';

  @override
  String get supportChatWelcomeMessage =>
      'Benvingut al nostre suport de xat! Som aquí per respondre a les teves preguntes o dubtes sobre la nostra cartera.';

  @override
  String get cardChatWelcomeMessage =>
      'Benvingut al nostre suport de xat! Som aquí per respondre a les teves preguntes o dubtes.';

  @override
  String get creator => 'Creador';

  @override
  String get contractAddress => 'Adreça de contacte';

  @override
  String get lastMetadataSync => 'Última sinc de metadades';

  @override
  String get e2eEncyptedChat => 'Xat xifrat d’extrem a extrem.';

  @override
  String get pincodeAttemptMessage =>
      'Has indicat un codi PIN incorrecte tres vegades. Per raons de seguretat, espera un minut abans de reintentar-ho.';

  @override
  String get verifyNow => 'Comprovar ara';

  @override
  String get verifyLater => 'Verificar més tard';

  @override
  String get welDone => 'Ben fet!';

  @override
  String get mnemonicsVerifiedMessage => 'Frase de recuperació guardada.';

  @override
  String get chatWith => 'Xat amb';

  @override
  String get sendAnEmail => 'Enviar un correu electrònic';

  @override
  String get livenessCardHowToGetIt =>
      'És fàcil! Fes una verificació KYC única a la cartera Altme (desenvolupada per ID360) i sol·demana una credencial de Liveness.';

  @override
  String get livenessCardExpirationDate =>
      'Aquesta credencial estarà activa durant 1 ANY. La renovació és senzilla';

  @override
  String get livenessCardWhyGetThisCard =>
      'Obtén una prova verificable d’humanitat, que demanen la majoria dels protocols DeFi, GameFi i dApps de Web3. Una vegada obtinguda, pots encunyar un NFT protector de privadesa i no transferible per a la verificació a la cadena de blocs sense mostrar dades personals.';

  @override
  String get livenessCardLongDescription =>
      'La credencial és una prova verificable d’humanitat. Utilitza-ho per demostrar que no ets un robot quan ho demanin els protocols DeFi, jocs Onchain o dApps de Web3.';

  @override
  String get chat => 'Xat';

  @override
  String get needMnemonicVerificatinoDescription =>
      'Cal que verifiquis les frases llavor de la cartera per protegir els teus actius.';

  @override
  String get succesfullyAuthenticated => 'Autenticació correcta.';

  @override
  String get authenticationFailed => 'Autenticació fallida.';

  @override
  String get documentType => 'Tipus de document';

  @override
  String get countryCode => 'Codi del país';

  @override
  String get deviceIncompatibilityMessage =>
      'El dispositiu no és compatible amb aquesta funció.';

  @override
  String get tezosProofMessage => '';

  @override
  String get ethereumProofMessage => '';

  @override
  String get fantomProofMessage => '';

  @override
  String get polygonProofMessage => '';

  @override
  String get binanceProofMessage => '';

  @override
  String get yearsOld => 'anys';

  @override
  String get youAreOver13 => 'Ets major de 13 anys';

  @override
  String get youAreOver15 => 'Ets major de 15 anys';

  @override
  String get youAreOver18 => 'Ets major de 18 anys';

  @override
  String get youAreOver21 => 'Ets major de 21 anys';

  @override
  String get youAreOver50 => 'Ets major de 50 anys';

  @override
  String get youAreOver65 => 'Ets major de 65 anys';

  @override
  String get polygon => 'Polygon';

  @override
  String get ebsi => 'EBSI';

  @override
  String get comingSoon => 'Properament';

  @override
  String get financeCredentialsHomeTitle => 'Les meves credencials financeres';

  @override
  String get financeCredentialsDiscoverTitle =>
      'Verificar credencials financeres';

  @override
  String get financeCredentialsDiscoverSubtitle =>
      'Accedeix a noves oportunitats d’inversió a Web3.';

  @override
  String get financeCredentialsHomeSubtitle =>
      'Accedeix a noves oportunitats d’inversió a Web3';

  @override
  String get hummanityProofCredentialsHomeTitle => 'La meva prova d’humanitat';

  @override
  String get hummanityProofCredentialsHomeSubtitle =>
      'Demostra fàcilment que no ets un bot sinó un humà.';

  @override
  String get hummanityProofCredentialsDiscoverTitle =>
      'Demostra que no ets un bot ni IA';

  @override
  String get hummanityProofCredentialsDiscoverSubtitle =>
      'Obtén una prova d’humanitat reutilitzable per compartir';

  @override
  String get socialMediaCredentialsHomeTitle =>
      'Els meus comptes de xarxes socials';

  @override
  String get socialMediaCredentialsHomeSubtitle =>
      'Demostra la propietat dels comptes a l’instant amb una prova de humanitat';

  @override
  String get socialMediaCredentialsDiscoverTitle =>
      'Verifica els teus comptes de xarxes socials';

  @override
  String get socialMediaCredentialsDiscoverSubtitle =>
      'Demostra la propietat dels teus comptes quan calgui';

  @override
  String get walletIntegrityCredentialsHomeTitle => 'Integritat de la cartera';

  @override
  String get walletIntegrityCredentialsHomeSubtitle => 'TBD';

  @override
  String get walletIntegrityCredentialsDiscoverTitle =>
      'Integritat de la cartera';

  @override
  String get walletIntegrityCredentialsDiscoverSubtitle => 'TBD';

  @override
  String get polygonCredentialsHomeSubtitle =>
      'Demostra els teus drets d’accés a l’ecosistema de Polygon';

  @override
  String get polygonCredentialsDiscoverSubtitle =>
      'Demostra els teus drets d’accés a l’ecosistema de Polygon';

  @override
  String get pendingCredentialsHomeTitle => 'Credencials pendents';

  @override
  String get pendingCredentialsHomeSubtitle =>
      'Demostra els teus drets d\'accés.';

  @override
  String get restore => 'Restaurar';

  @override
  String get backup => 'Copiar';

  @override
  String get takePicture => 'Fer una foto';

  @override
  String get kyc => 'KYC';

  @override
  String get aiSystemWasNotAbleToEstimateYourAge =>
      'El sistema d’IA no ha pogut calcular l’edat';

  @override
  String youGotAgeCredentials(Object credential) {
    return 'Tens la teva credencial $credential.';
  }

  @override
  String yourAgeEstimationIs(Object ageEstimate) {
    return 'El càlcul de la teva edat amb IA és de $ageEstimate anys';
  }

  @override
  String get credentialNotFound => 'Credencial no trobada';

  @override
  String get cryptographicProof => 'Prova criptogràfica';

  @override
  String get downloadingCircuitLoadingMessage =>
      'Descarregant circuits. Pot trigar una estona. Espera.';

  @override
  String get cryptoAccountAlreadyExistMessage =>
      'Sembla que ja hi ha un compte amb aquesta informació criptogràfica';

  @override
  String get errorGeneratingProof => 'Generació de prova fallida';

  @override
  String get createWalletMessage => 'Crea una cartera primer.';

  @override
  String get successfullyGeneratingProof => 'Prova generada correctament';

  @override
  String get wouldYouLikeToAcceptThisCredentialsFromThisOrganisation =>
      'Vols acceptar aquesta/es credencial/s d’aquesta organització?';

  @override
  String get thisOrganisationRequestsThisInformation => 'L’organització demana';

  @override
  String get iS => 'és';

  @override
  String get isSmallerThan => 'és inferior a';

  @override
  String get isBiggerThan => 'és superior a';

  @override
  String get isOneOfTheFollowingValues => 'és un dels següents valors';

  @override
  String get isNotOneOfTheFollowingValues => 'no és un dels següents valors';

  @override
  String get isNot => 'no és';

  @override
  String get approve => 'Aprovar';

  @override
  String get noInformationWillBeSharedFromThisCredentialMessage =>
      'No es compartirà cap informació d’aquesta credencial (prova de coneixement zero).';

  @override
  String get burn => 'Destruir';

  @override
  String get wouldYouLikeToConfirmThatYouIntendToBurnThisNFT =>
      'Segur que vols destruir el NFT?';

  @override
  String pleaseAddXtoConnectToTheDapp(Object chain) {
    return 'Afegeix el compte $chain per connectar-te a la dApp.';
  }

  @override
  String pleaseSwitchPolygonNetwork(Object networkType) {
    return 'Canvia a polygon $networkType per realitzar aquesta acció.';
  }

  @override
  String get oidc4vcProfile => 'Perfil OIDC4VC';

  @override
  String get pleaseSwitchToCorrectOIDC4VCProfile =>
      'Canvia al perfil OIDC4VC correcte.';

  @override
  String get authenticationSuccess => 'Autenticació correcta';

  @override
  String get format => 'Format';

  @override
  String get verifyIssuerWebsiteIdentity =>
      'Verificar la identitat del lloc web de l\'emissor';

  @override
  String get verifyIssuerWebsiteIdentitySubtitle =>
      'Per defecte: desactivat\nActivar per verificar la identitat del lloc web abans de l’accés.';

  @override
  String get developerMode => 'Mode desenvolupador';

  @override
  String get developerModeSubtitle =>
      'Activa el mode desenvolupador per accedir a eines de depuració avançades';

  @override
  String get confirmVerifierAccess => 'Confirma l’accés del verificador';

  @override
  String get confirmVerifierAccessSubtitle =>
      'Per defecte: activat\nDesactiva per saltar la confirmació quan comparteixis les teves credencials verificables.';

  @override
  String get secureAuthenticationWithPINCode =>
      'Autenticació segura amb codi PIN';

  @override
  String get secureAuthenticationWithPINCodeSubtitle =>
      'Per defecte: activat\nDesactivar per ometre el codi PIN per a l’autenticació del lloc web (no recomanat).';

  @override
  String youcanSelectOnlyXCredential(Object count) {
    return 'Només pots seleccionar $count credencial/s.';
  }

  @override
  String get theCredentialIsNotReady => 'La credencial no està a punt.';

  @override
  String get theCredentialIsNoMoreReady =>
      'La credencial ja no està disponible.';

  @override
  String get lowSecurity => 'Seguretat baixa';

  @override
  String get highSecurity => 'Seguretat alta';

  @override
  String get theRequestIsRejected => 'S’ha refusat la sol·licitud.';

  @override
  String get userPinIsIncorrect => 'PIN d’usuari incorrecte';

  @override
  String get security_level => 'Nivell de seguretat';

  @override
  String get userPinTitle => 'Dígits PIN de l’usuari: codi_preautoritzat Flux';

  @override
  String get userPinSubtitle =>
      'Per defecte: 6 DÍGITS\nPermetre gestionar codi PIN de 4 dígits';

  @override
  String get responseTypeNotSupported => 'Tipus de resposta no compatible';

  @override
  String get invalidRequest => 'Sol·licitud no vàlida';

  @override
  String get subjectSyntaxTypeNotSupported =>
      'Sintaxi del subjecte no compatible.';

  @override
  String get accessDenied => 'Accés refusat';

  @override
  String get thisRequestIsNotSupported => 'Sol·licitud no compatible';

  @override
  String get unsupportedCredential => 'Credencial no compatible';

  @override
  String get aloginIsRequired => 'Cal iniciar sessió';

  @override
  String get userConsentIsRequired => 'Cal consentiment d’usuari';

  @override
  String get theWalletIsNotRegistered => 'La cartera no està registrada';

  @override
  String get credentialIssuanceDenied => 'Emissió de credencial denegada';

  @override
  String get thisCredentialFormatIsNotSupported =>
      'Format de credencial no compatible';

  @override
  String get thisFormatIsNotSupported => 'Format no compatible';

  @override
  String get moreDetails => 'Més detalls';

  @override
  String get theCredentialOfferIsInvalid => 'Oferta de credencial no vàlida';

  @override
  String get dateOfRequest => 'Data de la demanda';

  @override
  String get keyDecentralizedIDP256 => 'Clau d’ID descentralitzada P-256';

  @override
  String get jwkDecentralizedIDP256 => 'JWK ID descentralitzada P-256';

  @override
  String get defaultDid => 'DID per defecte';

  @override
  String get selectOneOfTheDid => 'Selecciona un dels DID';

  @override
  String get theServiceIsNotAvailable => 'Servei no disponible';

  @override
  String get issuerDID => 'Emissor DID';

  @override
  String get subjectDID => 'Subjecte DID';

  @override
  String get type => 'Tipus';

  @override
  String get credentialExpired => 'Credencial caducada';

  @override
  String get incorrectSignature => 'Signatura incorrecta';

  @override
  String get revokedOrSuspendedCredential => 'Credencial revocada o suspesa';

  @override
  String get display => 'Mostrar';

  @override
  String get download => 'Descarregar';

  @override
  String get successfullyDownloaded => 'Descàrrega realitzada';

  @override
  String get advancedSecuritySettings => 'Configuració de seguretat avançada';

  @override
  String get theIssuanceOfThisCredentialIsPending =>
      'L’emissió d’aquesta credencial està pendent';

  @override
  String get clientId => 'ID del client';

  @override
  String get clientSecret => 'Client secret';

  @override
  String get walletProfiles => 'Perfils de la cartera';

  @override
  String get walletProfilesDescription =>
      'Escull un perfil SSI o personalitza el teu';

  @override
  String get protectYourWallet => 'Protegeix la teva cartera';

  @override
  String get protectYourWalletMessage =>
      'Utilitza l’empremta digital, la cara o el PIN del dispositiu per protegir i desbloquejar la teva cartera. Dades xifrades i segures en aquest dispositiu.';

  @override
  String get pinUnlock => 'Desbloqueig PIN';

  @override
  String get secureWithDevicePINOnly => 'Protegir només amb PIN del dispositiu';

  @override
  String get biometricUnlock => 'Desbloqueig biomètric';

  @override
  String get secureWithFingerprint => 'Protegir amb empremta digital';

  @override
  String get pinUnlockAndBiometric2FA => 'Desbloqueig PIN + biomètric (2FA)';

  @override
  String get secureWithFingerprintAndPINBackup =>
      'Protegir amb empremta digital + PIN de seguretat';

  @override
  String get secureYourWalletWithPINCodeAndBiometrics =>
      'Protegeix la cartera amb codi PIN i biomètrica';

  @override
  String get twoFactorAuthenticationHasBeenEnabled =>
      'Autenticació de dos factors activada.';

  @override
  String get initialization => 'Inicialització';

  @override
  String get login => 'Iniciar sessió';

  @override
  String get password => 'Contrasenya';

  @override
  String get pleaseEnterYourEmailAndYourCompanyPasswordToCreateYourAccount =>
      'Indica el correu electrònic i la contrasenya de la teva empresa per crear el compte';

  @override
  String get enterTheSecurityCodeThatWeSentYouByEmail =>
      'Indica el codi de seguretat que t’hem enviat';

  @override
  String get enterTheSecurityCode => 'Indica el codi de seguretat';

  @override
  String get yourEmail => 'El teu correu electrònic';

  @override
  String get publicKeyOfWalletInstance =>
      'Clau pública de la instància de la cartera';

  @override
  String get walletInstanceKey => 'Clau d’instància de la cartera';

  @override
  String get organizationProfile => 'Perfil de l’organització';

  @override
  String get profileName => 'Nom del perfil';

  @override
  String get companyName => 'Nom de l’empresa';

  @override
  String get configFileIdentifier => 'Identificador de l’arxiu de config';

  @override
  String get updateYourWalletConfigNow => 'Actualitzar ara config de cartera';

  @override
  String get updateConfigurationNow => 'Actualitza la configuració ara';

  @override
  String
  get pleaseEnterYourEmailAndPasswordToUpdateYourOrganizationWalletConfiguration =>
      'Indica el correu electrònic i la contrasenya per actualitzar la configuració de la cartera de la teva organització.';

  @override
  String get congrats => 'Felicitats!';

  @override
  String get yourWalletConfigurationHasBeenSuccessfullyUpdated =>
      'La configuració de la cartera s’ha actualitzat correctament';

  @override
  String get continueString => 'Continuar';

  @override
  String get walletProvider => 'Proveïdor de cartera';

  @override
  String get clientTypeSubtitle =>
      'Predeterminat: DID\nDesplaci per canviar el tipus de client';

  @override
  String get thisTypeProofCannotBeUsedWithThisVCFormat =>
      'Aquest tipus de prova no es pot fer servir amb aquest format de CV';

  @override
  String get blockchainCardsDiscoverTitle =>
      'Obtenir prova de propietat de compte cripto';

  @override
  String get blockchainCardsDiscoverSubtitle =>
      'Obtenir prova de propietat de compte de criptoactius';

  @override
  String get successfullyAddedEnterpriseAccount =>
      'Compte d\'Organització/Empresa afegida amb èxit!';

  @override
  String get successfullyUpdatedEnterpriseAccount =>
      'Compte d\'Organització/Empresa actualitzada amb èxit!';

  @override
  String get thisWalleIsAlreadyConfigured =>
      'Aquesta cartera ja està configurada';

  @override
  String get walletSettings => 'Configuració de la cartera';

  @override
  String get walletSettingsDescription => 'Trieu el vostre idioma';

  @override
  String get languageSelectorTitle => 'catalan';

  @override
  String get french => 'Français';

  @override
  String get spanish => 'Español';

  @override
  String get catalan => 'Català';

  @override
  String get english => 'English';

  @override
  String get phoneLanguage => 'Idioma del telèfon';

  @override
  String get cardIsValid => 'La targeta és vàlida';

  @override
  String get cardIsExpired => 'La targeta ha caducat';

  @override
  String get signatureIsInvalid => 'La signatura no és vàlida';

  @override
  String get statusIsInvalid => 'L\'estat no és vàlid';

  @override
  String get statuslListSignatureFailed =>
      'Error en la signatura de la llista d\'estats';

  @override
  String get statusList => 'Llista d\'estats';

  @override
  String get statusListIndex => 'Índex de la llista d\'estats';

  @override
  String get theWalletIsSuspended => 'La cartera està suspesa.';

  @override
  String get jwkThumbprintP256Key => 'Empremta digital JWK P-256';

  @override
  String get walletBlockedPopupTitle => 'Bloquejat 10 minuts';

  @override
  String get walletBlockedPopupDescription =>
      'Massa intents fallits, la teva cartera digital està bloquejada per seguretat.\nReinicia la teva cartera per utilitzar els serveis de nou.';

  @override
  String get deleteMyWalletForWrontPincodeTitle =>
      'Compte bloquejat després de 3 intents fallits';

  @override
  String get deleteMyWalletForWrontPincodeDescription =>
      'Per la teva seguretat, has de reiniciar la teva cartera digital per utilitzar els nostres serveis de nou.';

  @override
  String get walletBloced => 'Compte bloquejat';

  @override
  String get deleteMyWallet => 'Eliminar el meu compte';

  @override
  String get pincodeRules =>
      'El teu codi secret no pot ser una seqüència ni tenir 4 dígits idèntics.';

  @override
  String get pincodeSerie => 'No pots tenir 4 dígits idèntics.';

  @override
  String get pincodeSequence => 'No pots tenir una seqüència de 4 dígits.';

  @override
  String get pincodeDifferent => 'Codi incorrecte.\nEls codis no són iguals.';

  @override
  String codeSecretIncorrectDescription(Object count, Object plural) {
    return 'Ves amb compte, et queden $count intent$plural.';
  }

  @override
  String get languageSettings => 'Configuració d\'idioma';

  @override
  String get languageSettingsDescription => 'Escull el teu idioma';

  @override
  String get themeSettings => 'Configuració de tema';

  @override
  String get themeSettingsDescription => 'Escull el teu tema';

  @override
  String couldNotFindTheAccountWithThisAddress(Object address) {
    return 'No s\'ha pogut trobar l\'adreça $address a la teva llista de comptes.';
  }

  @override
  String deleteAccountMessage(Object account) {
    return 'Estàs segur que vols eliminar $account?';
  }

  @override
  String get cannotDeleteCurrentAccount =>
      'Ho sento, no pots eliminar el compte actual';

  @override
  String get invalidClientErrorDescription =>
      'client_id no compleix amb client_id_scheme';

  @override
  String get vpFormatsNotSupportedErrorDescription =>
      'La cartera digital no admet cap dels formats sol·licitats pel Verificador, com els inclosos en el paràmetre de registre vp_formats.';

  @override
  String get invalidPresentationDefinitionUriErrorDescription =>
      'No es pot accedir a la URL de \'Definició de Presentació\'.';

  @override
  String get toStopDisplayingThisPopupDeactivateTheDeveloperModeInTheSettings =>
      'Per deixar de mostrar aquesta finestra, desactiva el \'mode desenvolupador\' a la configuració.';

  @override
  String get warningDialogSubtitle =>
      'La pàgina de recuperació conté informació sensible. Si us plau, assegura\'t de mantenir-la privada.';

  @override
  String get accountPrivateKeyAlert =>
      'La pàgina de recuperació conté informació sensible. Si us plau, assegura\'t de mantenir-la privada.';

  @override
  String get etherlinkNetwork => 'Xarxa Etherlink';

  @override
  String get etherlinkAccount => 'Compte Etherlink';

  @override
  String get etherlinkAccountDescription =>
      'Crear una nova adreça blockchain Etherlink';

  @override
  String get etherlinkAccountCreationCongratulations =>
      'El teu nou compte Etherlink ha estat creat amb èxit.';

  @override
  String get etherlinkProofMessage => '';

  @override
  String get notification => 'Notificació';

  @override
  String get notifications => 'Notificacions';

  @override
  String get notificationTitle =>
      '¡Benvingut a les Notificacions!\nMantingueu-vos informat d\'actualitzacions importants.';

  @override
  String get chatRoom => 'Sala de xat';

  @override
  String get notificationRoom => 'Sala de notificacions';

  @override
  String get notificationSubtitle => 'Habilitar per rebre notificacions';

  @override
  String get header => 'Encapçalament';

  @override
  String get payload => 'Payload';

  @override
  String get data => 'Dades';

  @override
  String get keyBindingHeader => 'Key Binding Header';

  @override
  String get keyBindingPayload => 'Key Binding Payload';

  @override
  String get ebsiV4DecentralizedId => 'did:key EBSI V4 P-256';

  @override
  String get noNotificationsYet => 'Encara no hi ha notificacions';

  @override
  String get activityLog => 'Registre d\'Activitat';

  @override
  String get activityLogDescription => 'Veure les teves activitats';

  @override
  String get walletInitialized => 'Cartera digital inicialitzada';

  @override
  String get backupCredentials => 'Credencials de còpia de seguretat';

  @override
  String get restoredCredentials => 'Credencials restaurades';

  @override
  String deletedCredential(Object credential) {
    return 'Credencial $credential eliminada';
  }

  @override
  String presentedCredential(Object credential, Object domain) {
    return 'Credencial $credential presentada a $domain';
  }

  @override
  String get keysImported => 'Claus importades';

  @override
  String get approveProfileTitle => 'Instal·lar configuració';

  @override
  String approveProfileDescription(Object company) {
    return 'Autoritzes instal·lar la configuració de $company?';
  }

  @override
  String get updateProfileTitle => 'Actualitzar configuració';

  @override
  String updateProfileDescription(Object company) {
    return 'Autoritzes actualitzar la configuració de $company?';
  }

  @override
  String get replaceProfileTitle => 'Instal·lar una nova configuració';

  @override
  String replaceProfileDescription(Object company) {
    return 'Autoritzes reemplaçar la configuració actual amb la de $company?';
  }

  @override
  String get saveBackupCredentialSubtitle2 =>
      'Per recuperar les teves credencials necessitaràs aquest fitxer de còpia de seguretat.';

  @override
  String get createWallet => 'Crear cartera digital';

  @override
  String get restoreWallet => 'Restaurar cartera digital';

  @override
  String get showWalletRecoveryPhraseSubtitle2 =>
      'Aquesta frase de recuperació serà requerida per restaurar una cartera digital a la instal·lació.';

  @override
  String get documentation => 'Documentació';

  @override
  String get restoreACryptoWallet => 'Restaurar una cripto cartera';

  @override
  String restoreAnAppBackup(Object appName) {
    return 'Restaurar una còpia de seguretat de $appName';
  }

  @override
  String get credentialPickShare => 'Compartir';

  @override
  String get credentialPickTitle =>
      'Escull la(es) credencial(s) que vols obtenir';

  @override
  String get credentialShareTitle =>
      'Escull la(es) credencial(s) per compartir';

  @override
  String get enterYourSecretCode => 'Introdueix el teu codi secret.';

  @override
  String get jwk => 'JWK';

  @override
  String get typeYourPINCodeToOpenTheWallet =>
      'Introdueix el teu codi PIN per obrir la cartera';

  @override
  String get typeYourPINCodeToShareTheData =>
      'Introdueix el teu codi PIN per compartir les dades';

  @override
  String get typeYourPINCodeToAuthenticate =>
      'Introdueix el teu codi PIN per autenticar-te';

  @override
  String get credentialIssuanceIsStillPending =>
      'L\'emissió de la credencial està pendent';

  @override
  String get bakerFee => 'Comissió de Baker';

  @override
  String get storageFee => 'Comissió d\'emmagatzematge';

  @override
  String get doYouWantToSetupTheProfile => 'Vols configurar el perfil?';

  @override
  String get thisFeatureIsNotSupportedYetForEtherlink =>
      'Aquesta funció encara no és compatible amb Etherlink Chain.';

  @override
  String get walletSecurityAndBackup =>
      'Seguretat i còpia de seguretat de la cartera';

  @override
  String addedCredential(Object credential, Object domain) {
    return 'Credencial $credential afegida per $domain';
  }

  @override
  String get reject => 'Reject';

  @override
  String get operation => 'Operation';

  @override
  String get chooseYourSSIProfileOrCustomizeYourOwn =>
      'Choose your wallet profile or customize your own';

  @override
  String get recoveryPhraseIncorrectErrorMessage =>
      'Please try again with correct order.';

  @override
  String get invalidCode => 'Invalid code';

  @override
  String get back => 'Back';

  @override
  String get iaAnalyze =>
      'Data will be shared with a remote AI engine. Don\'t share personal data.';

  @override
  String get iaAnalyzeTitle => 'AI Agent';

  @override
  String get deleteDigit => 'Esborrar';

  @override
  String get aiPleaseWait => 'This treatment can take up to 1 min';

  @override
  String get trustedList => 'Use trusted list';

  @override
  String get trustedListSubtitle =>
      'List of trusted entities in the current ecosystem. You are warned in case of interaction with non trusted entity.';

  @override
  String get notTrustedEntity =>
      'This entity is not in the trusted list. You should be very cautious with untrusted entities.';

  @override
  String get acceptanceRequest => 'Payment request';

  @override
  String get pay => 'share and pay';
}
