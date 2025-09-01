// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get genericError => '¡Se ha producido un error!';

  @override
  String get credentialListTitle => 'Credenciales';

  @override
  String credentialDetailIssuedBy(Object issuer) {
    return 'Emitido por $issuer';
  }

  @override
  String get listActionRefresh => 'Actualizar';

  @override
  String get listActionViewList => 'Ver como lista';

  @override
  String get listActionViewGrid => 'Ver como cuadrícula';

  @override
  String get listActionFilter => 'Filtro';

  @override
  String get listActionSort => 'Ordenar';

  @override
  String get onBoardingStartSubtitle => 'Lorem ipsum dolor sit ame';

  @override
  String get onBoardingTosTitle => 'Términos y condiciones';

  @override
  String get onBoardingTosText =>
      'Al tocar Aceptar, \"Acepto los términos y condiciones, y la divulgación de esta información.\"';

  @override
  String get onBoardingTosButton => 'Aceptar';

  @override
  String get onBoardingRecoveryTitle => 'Recuperación de clave';

  @override
  String get onBoardingRecoveryButton => 'Recuperar';

  @override
  String get onBoardingGenPhraseTitle => 'Frase de recuperación';

  @override
  String get onBoardingGenPhraseButton => 'Continuar';

  @override
  String get onBoardingGenTitle => 'Generación de clave privada';

  @override
  String get onBoardingGenButton => 'Generar';

  @override
  String get onBoardingSuccessTitle => 'Identificador creado';

  @override
  String get onBoardingSuccessButton => 'Continuar';

  @override
  String get credentialDetailShare => 'Compartir por código QR';

  @override
  String get credentialAddedMessage => '¡Se ha añadido una nueva credencial!';

  @override
  String get credentialDetailDeleteCard => 'Eliminar esta tarjeta';

  @override
  String get credentialDetailDeleteConfirmationDialog =>
      '¿Seguro que desea eliminar esta credencial?';

  @override
  String get credentialDetailDeleteConfirmationDialogYes => 'Sí';

  @override
  String get credentialDetailDeleteConfirmationDialogNo => 'No';

  @override
  String get credentialDetailDeleteSuccessMessage => 'Eliminación realizada.';

  @override
  String get credentialDetailEditConfirmationDialog =>
      '¿Seguro que desea editar esta credencial?';

  @override
  String get credentialDetailEditConfirmationDialogYes => 'Guardar';

  @override
  String get credentialDetailEditConfirmationDialogNo => 'Cancelar';

  @override
  String get credentialDetailEditSuccessMessage => 'Edición realizada.';

  @override
  String get credentialDetailCopyFieldValue =>
      '¡Valor de campo copiado en el portapapeles!';

  @override
  String get credentialDetailStatus => 'Estado de verificación';

  @override
  String get credentialPresentTitle => 'Seleccionar credencial(es)';

  @override
  String get credentialPresentTitleDIDAuth => 'Solicitud de DIDAuth';

  @override
  String get credentialPresentRequiredCredential => 'Alguien pide su(s)';

  @override
  String get credentialPresentConfirm => 'Seleccionar credencial(es)';

  @override
  String get credentialPresentCancel => 'Rechazar';

  @override
  String get selectYourTezosAssociatedWallet =>
      'Seleccione su cartera asociada a Tezos';

  @override
  String get credentialPickSelect => 'Seleccione su credencial';

  @override
  String get siopV2credentialPickSelect =>
      'Elija solo una credencial que presentar de su cartera';

  @override
  String get credentialPickAlertMessage =>
      '¿Quiere poner un alias a esta credencial?';

  @override
  String get credentialReceiveTitle => 'Oferta de credenciales';

  @override
  String get credentialReceiveHost => 'desea enviarle una credencial';

  @override
  String get credentialAddThisCard => 'Añadir esta tarjeta';

  @override
  String get credentialReceiveCancel => 'Cancelar esta tarjeta';

  @override
  String get credentialDetailListTitle => 'Mi cartera';

  @override
  String get communicationHostAllow => 'Permitir';

  @override
  String get communicationHostDeny => 'Denegar';

  @override
  String get scanTitle => 'Escanear código QR';

  @override
  String get scanPromptHost => '¿Confía en este host?';

  @override
  String get scanRefuseHost => 'La comunicación solicitada se ha denegado.';

  @override
  String get scanUnsupportedMessage => 'La URL extraída no es válida.';

  @override
  String get qrCodeSharing => 'Ahora comparte';

  @override
  String get qrCodeNoValidMessage =>
      'Este código QR no contiene un mensaje válido.';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get personalTitle => 'Personal';

  @override
  String get termsTitle => 'Términos y condiciones';

  @override
  String get recoveryKeyTitle => 'Frase de recuperación';

  @override
  String get showRecoveryPhrase => 'Mostrar frase de recuperación';

  @override
  String get warningDialogTitle => 'Cuidado';

  @override
  String get recoveryText => 'Introduzca su frase de recuperación';

  @override
  String get recoveryMnemonicHintText =>
      'Escriba aquí su frase de recuperación.\nUna vez que escriba sus 12 palabras,\ntoque Importar.';

  @override
  String get recoveryMnemonicError =>
      'Introduzca una frase mnemotécnica válida';

  @override
  String get showDialogYes => 'Continuar';

  @override
  String get showDialogNo => 'Cancelar';

  @override
  String get supportTitle => 'Asistencia';

  @override
  String get noticesTitle => 'Avisos';

  @override
  String get resetWalletButton => 'Restablecer Cartera';

  @override
  String get resetWalletConfirmationText =>
      '¿Seguro que desea restablecer su cartera?';

  @override
  String get selectThemeText => 'Seleccione el tema';

  @override
  String get lightThemeText => 'Tema claro';

  @override
  String get darkThemeText => 'Tema oscuro';

  @override
  String get systemThemeText => 'Tema del sistema';

  @override
  String get genPhraseInstruction =>
      'Escriba las palabras, descargue el archivo de copia de respaldo y guárdelo seguro';

  @override
  String get genPhraseExplanation =>
      'Si pierde el acceso a la cartera, las necesitará en orden correcto y el archivo de respaldo para recuperar certificados.';

  @override
  String get errorGeneratingKey =>
      'Error al generar la clave, vuelva a intentarlo';

  @override
  String get documentHeaderTooltipName => 'Juan Pérez';

  @override
  String get documentHeaderTooltipJob => 'Operador de criptomonedas';

  @override
  String get documentHeaderTooltipLabel => 'Estado:';

  @override
  String get documentHeaderTooltipValue => 'Válido';

  @override
  String get didDisplayId => 'DID';

  @override
  String get blockChainDisplayMethod => 'Blockchain';

  @override
  String get blockChainAdress => 'Dirección';

  @override
  String get didDisplayCopy => 'Copiar DID en el portapapeles';

  @override
  String get adressDisplayCopy => 'Copiar dirección en el portapapeles';

  @override
  String get personalSave => 'Guardar';

  @override
  String get personalSubtitle =>
      'La información de su perfil puede usarse para completar un certificado si es necesario';

  @override
  String get personalFirstName => 'Nombre';

  @override
  String get personalLastName => 'Apellidos';

  @override
  String get personalPhone => 'Teléfono';

  @override
  String get personalAddress => 'Dirección';

  @override
  String get personalMail => 'Email';

  @override
  String get lastName => 'Apellidos';

  @override
  String get firstName => 'Nombre';

  @override
  String get gender => 'sexo';

  @override
  String get birthdate => 'Fecha de nacimiento';

  @override
  String get birthplace => 'Lugar de nacimiento';

  @override
  String get address => 'Dirección';

  @override
  String get maritalStatus => 'Estado civil';

  @override
  String get nationality => 'Nacionalidad';

  @override
  String get identifier => 'Identificador';

  @override
  String get issuer => 'Emitido por';

  @override
  String get workFor => 'Trabaja en';

  @override
  String get startDate => 'Desde';

  @override
  String get endDate => 'Hasta';

  @override
  String get employmentType => 'Tipo de empleo';

  @override
  String get jobTitle => 'Cargo';

  @override
  String get baseSalary => 'Salario';

  @override
  String get expires => 'Caducidad';

  @override
  String get generalInformationLabel => 'Información general';

  @override
  String get learningAchievement => 'Logro';

  @override
  String get signedBy => 'Firmado por';

  @override
  String get from => 'De';

  @override
  String get to => 'A';

  @override
  String get credential => 'Credencial';

  @override
  String get issuanceDate => 'Fecha de emisión';

  @override
  String get appContactWebsite => 'Sitio web';

  @override
  String get trustFrameworkDescription =>
      'El marco de confianza es un conjunto de registros que ofrecen una base segura y fiable para que las entidades del sistema confíen e interactúen entre sí.';

  @override
  String get confimrDIDAuth => '¿Desea iniciar sesión en el sitio?';

  @override
  String get evidenceLabel => 'Evidencia';

  @override
  String get networkErrorBadRequest => 'Solicitud errónea';

  @override
  String get networkErrorConflict => 'Error debido a un conflicto';

  @override
  String get networkErrorPreconditionFailed =>
      'El servidor no cumple una de las condiciones previas.';

  @override
  String get networkErrorCreated => '';

  @override
  String get networkErrorGatewayTimeout =>
      'Tiempo de espera de puerta de enlace alcanzado';

  @override
  String get networkErrorInternalServerError =>
      'Este es un error interno del servidor. Contacte con el administrador del servidor';

  @override
  String get networkErrorMethodNotAllowed =>
      'El usuario no tiene derechos de acceso al contenido';

  @override
  String get networkErrorNoInternetConnection => 'Sin conexión a Internet';

  @override
  String get networkErrorNotAcceptable => 'No aceptable';

  @override
  String get networkErrorNotImplemented => 'No implementado';

  @override
  String get networkErrorOk => '';

  @override
  String get networkErrorRequestCancelled => 'Solicitud cancelada';

  @override
  String get networkErrorRequestTimeout => 'Tiempo de espera de solicitud';

  @override
  String get networkErrorSendTimeout =>
      'Enviar tiempo de espera en conexión con servidor API';

  @override
  String get networkErrorServiceUnavailable => 'Servicio no disponible';

  @override
  String get networkErrorTooManyRequests =>
      'El usuario ha enviado demasiadas solicitudes en un tiempo dado';

  @override
  String get networkErrorUnableToProcess => 'No se pueden procesar los datos';

  @override
  String get networkErrorUnauthenticated =>
      'El usuario debe autenticarse para obtener la respuesta solicitada';

  @override
  String get networkErrorUnauthorizedRequest => 'Solicitud no autorizada';

  @override
  String get networkErrorUnexpectedError => 'Ha habido un error inesperado';

  @override
  String get networkErrorNotFound => 'No encontrado';

  @override
  String get active => 'Activo';

  @override
  String get expired => 'Caducado';

  @override
  String get revoked => 'Revocado';

  @override
  String get ok => 'ACEPTAR';

  @override
  String get unavailable_feature_title => 'Función no disponible';

  @override
  String get unavailable_feature_message =>
      'Función no disponible en el navegador';

  @override
  String get personalSkip => 'OMITIR';

  @override
  String get restoreCredential => 'Restablecer credenciales';

  @override
  String get backupCredential => 'Hacer copia de respaldo de credenciales';

  @override
  String get backupCredentialPhrase =>
      'Escriba las palabras, descargue el archivo de copia de respaldo y guárdelo seguro';

  @override
  String get backupCredentialPhraseExplanation =>
      'Para hacer una copia de respaldo de credenciales, escriba su frase de recuperación y guárdela segura.';

  @override
  String get backupCredentialButtonTitle => 'Guardar el archivo';

  @override
  String get needStoragePermission =>
      'Necesita permiso de almacenamiento para descargar el archivo.';

  @override
  String get backupCredentialNotificationTitle => 'Sin errores';

  @override
  String get backupCredentialNotificationMessage =>
      'Archivo descargado. Toque para abrir el archivo.';

  @override
  String get backupCredentialError =>
      'Ha habido un problema. Inténtelo más tarde.';

  @override
  String get backupCredentialSuccessMessage => 'Archivo descargado.';

  @override
  String get restorationCredentialWarningDialogSubtitle =>
      'Si restablece, se borrarán todas las credenciales que tiene en la cartera.';

  @override
  String get recoveryCredentialPhrase =>
      'Escriba las palabras y cargue el archivo de copia de respaldo si lo ha guardado';

  @override
  String get recoveryCredentialPhraseExplanation =>
      'Si pierde sus credenciales, necesitará ambas palabras en orden correcto y un archivo de copia de respaldo cifrado para recuperarlas';

  @override
  String get recoveryCredentialButtonTitle =>
      'Cargar archivo de copia de respaldo';

  @override
  String recoveryCredentialSuccessMessage(Object postfix) {
    return 'Se ha(n) recuperado $postfix.';
  }

  @override
  String get recoveryCredentialJSONFormatErrorMessage =>
      'Cargue el archivo válido.';

  @override
  String get recoveryCredentialAuthErrorMessage =>
      'Frase mnemotécnica incorrecta o archivo cargado dañado.';

  @override
  String get recoveryCredentialDefaultErrorMessage =>
      'Ha habido un problema. Inténtelo más tarde.';

  @override
  String get selfIssuedCreatedSuccessfully => 'Credencial autoemitida creada';

  @override
  String get companyWebsite => 'Sitio web de la empresa';

  @override
  String get submit => 'Enviar';

  @override
  String get insertYourDIDKey => 'Inserte su DID';

  @override
  String get importYourRSAKeyJsonFile => 'Importe su archivo json de clave RSA';

  @override
  String get didKeyAndRSAKeyVerifiedSuccessfully =>
      'Las claves DID y RSA se han verificado';

  @override
  String get pleaseEnterYourDIDKey => 'Escriba su DID';

  @override
  String get pleaseImportYourRSAKey => 'Importe su clave RSA';

  @override
  String get confirm => 'Confirmar';

  @override
  String get pleaseSelectRSAKeyFileWithJsonExtension =>
      'Seleccione el archivo de clave RSA (extensión json)';

  @override
  String get rsaNotMatchedWithDIDKey => 'La clave RSA no coincide con el DID';

  @override
  String get didKeyNotResolved => 'DID no resuelto';

  @override
  String get anUnknownErrorHappened => 'Ha habido un error inesperado';

  @override
  String get walletType => 'Tipo de cartera';

  @override
  String get chooseYourWalletType => 'Elija el tipo de cartera';

  @override
  String get proceed => 'Continuar';

  @override
  String get enterpriseWallet => 'Cartera de empresa';

  @override
  String get personalWallet => 'Cartera personal';

  @override
  String get failedToVerifySelfIssuedCredential =>
      'Error al verificar la credencial autoemitida';

  @override
  String get failedToCreateSelfIssuedCredential =>
      'Error al crear la credencial autoemitida';

  @override
  String get credentialVerificationReturnWarning =>
      'Al verificar la credencial, se han activado avisos. ';

  @override
  String get failedToVerifyCredential => 'Error al verificar la credencial.';

  @override
  String get somethingsWentWrongTryAgainLater =>
      'Ha habido un problema, inténtelo más tarde. ';

  @override
  String get successfullyPresentedYourCredential =>
      '¡Se han presentado su(s) credencial(es)!';

  @override
  String get successfullyPresentedYourDID => '¡Se ha presentado su DID!';

  @override
  String get thisQRCodeIsNotSupported => 'Este código QR no es compatible.';

  @override
  String get thisUrlDoseNotContainAValidMessage =>
      'Esta URL no contiene un mensaje válido.';

  @override
  String get anErrorOccurredWhileConnectingToTheServer =>
      'Ha habido un error al conectar con el servidor.';

  @override
  String get failedToSaveMnemonicPleaseTryAgain =>
      'Error al guardar la frase mnemotécnica, reinténtelo';

  @override
  String get failedToLoadProfile => 'Error al cargar el perfil. ';

  @override
  String get failedToSaveProfile => 'Error al guardar el perfil. ';

  @override
  String get failedToLoadDID => 'Error al cargar el DID. ';

  @override
  String get personalOpenIdRestrictionMessage => 'Cartera personal sin acceso.';

  @override
  String get credentialEmptyError =>
      'No tiene ninguna credencial en su cartera.';

  @override
  String get credentialPresentTitleSiopV2 => 'Presentar credencial';

  @override
  String get confirmSiopV2 => 'Confirme la credencial presentada';

  @override
  String get storagePermissionRequired => 'Permiso de almacenamiento requerido';

  @override
  String get storagePermissionDeniedMessage =>
      'Conceda acceso de almacenamiento para cargar el archivo.';

  @override
  String get storagePermissionPermanentlyDeniedMessage =>
      'Permiso de almacenamiento necesario para cargar el archivo. Permita el acceso de almacenamiento en configuración de la aplicación.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get loading => 'Espere un momento...';

  @override
  String get issuerWebsitesTitle => 'Obtener credenciales';

  @override
  String get getCredentialTitle => 'Obtener credenciales';

  @override
  String get participantCredential => 'Pase Gaia-X';

  @override
  String get phonePassCredential => 'Prueba de teléfono';

  @override
  String get emailPassCredential => 'Prueba de email';

  @override
  String get needEmailPass => 'Primero necesita obtener una prueba de email';

  @override
  String get signature => 'Firma';

  @override
  String get proof => 'Prueba';

  @override
  String get verifyMe => 'Verificarme';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get credentialAlias => 'Alias de credencial';

  @override
  String get verificationStatus => 'Estado de verificación';

  @override
  String get cardsPending => 'Tarjeta pendiente';

  @override
  String get unableToProcessTheData => 'No se pueden procesar los datos';

  @override
  String get unimplementedQueryType => 'Tipo de consulta no implementado';

  @override
  String get onSubmittedPassBasePopUp => 'Recibirá un email';

  @override
  String get myCollection => 'Mi colección';

  @override
  String get items => 'elementos';

  @override
  String get succesfullyUpdated => 'Actualizado.';

  @override
  String get generate => 'Generar';

  @override
  String get myAssets => 'Mis activos';

  @override
  String get search => 'Buscar';

  @override
  String get professional => 'Profesional';

  @override
  String get splashSubtitle =>
      'Tenga su propia identidad digital y activos digitales.';

  @override
  String get poweredBy => 'Con tecnología de';

  @override
  String get splashLoading => 'Cargando...';

  @override
  String get version => 'Versión';

  @override
  String get cards => 'Tarjetas';

  @override
  String get nfts => 'NFT';

  @override
  String get coins => 'Monedas';

  @override
  String get getCards => 'Obtener credenciales';

  @override
  String get close => 'Cerrar';

  @override
  String get profile => 'Perfil';

  @override
  String get infos => 'Información';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get enterNewPinCode => 'Cree un código PIN\npara proteger su cartera';

  @override
  String get confirmYourPinCode => 'Confirme su código PIN';

  @override
  String get walletAltme => 'Cartera Altme';

  @override
  String get createTitle => 'Crear o importar una cartera';

  @override
  String get createSubtitle =>
      '¿Desea crear una nueva cartera o importar una existente?';

  @override
  String get enterYourPinCode => 'Escriba su código PIN';

  @override
  String get changePinCode => 'Cambiar código PIN';

  @override
  String get tryAgain => 'Intentarlo de nuevo';

  @override
  String get credentialSelectionListEmptyError =>
      'No tiene la credencial requerida para continuar.';

  @override
  String get trustedIssuer => 'El emisor está aprobado por EBSI.';

  @override
  String get yourPinCodeChangedSuccessfully => 'Se ha cambiado su código PIN';

  @override
  String get advantagesCards => 'Tarjetas de ventajas';

  @override
  String get advantagesDiscoverCards => 'Reciba recompensas exclusivas';

  @override
  String get identityCards => 'Tarjetas de identidad';

  @override
  String get identityDiscoverCards => 'Simplificar verificación de ID';

  @override
  String get contactInfoCredentials => 'Datos de contacto';

  @override
  String get contactInfoDiscoverCredentials =>
      'Verificar sus datos de contacto';

  @override
  String get myProfessionalCards => 'Tarjetas profesionales';

  @override
  String get otherCards => 'Otras tarjetas';

  @override
  String get inMyWallet => 'En mi cartera';

  @override
  String get details => 'Detalles';

  @override
  String get getIt => 'Obtener';

  @override
  String get getItNow => 'Obtener ahora';

  @override
  String get getThisCard => 'Obtener esta tarjeta';

  @override
  String get drawerBiometrics => 'Autenticación biométrica';

  @override
  String get drawerTalaoCommunityCard => 'Tarjeta de Comunidad de Talao';

  @override
  String get drawerTalaoCommunityCardTitle =>
      'Importe su dirección de Ethereum y reciba su Tarjeta de Comunidad.';

  @override
  String get drawerTalaoCommunityCardSubtitle =>
      'Acceda a los mejores descuentos, programas de afiliación y tarjetas de vales de nuestro ecosistema de socios.';

  @override
  String get drawerTalaoCommunityCardTextBoxMessage =>
      'Tras escribir su clave privada, toque Importar.\nAsegúrese de escribir la clave privada de Ethereum con su token de Talao.';

  @override
  String get drawerTalaoCommunityCardSubtitle2 =>
      'La cartera es de autocustodia. Nunca accedemos a sus claves privadas o fondos.';

  @override
  String get drawerTalaoCommunityCardKeyError =>
      'Escriba una clave privada válida';

  @override
  String get loginWithBiometricsMessage =>
      'Desbloquee rápido su cartera sin contraseña ni código PIN';

  @override
  String get manage => 'Administrar';

  @override
  String get wallet => 'Cartera';

  @override
  String get manageAccounts => 'Administrar cuentas de blockchain';

  @override
  String get blockchainAccounts => 'Cuentas de blockchain';

  @override
  String get educationCredentials => 'Credenciales de formación';

  @override
  String get educationDiscoverCredentials =>
      'Verifique su trayectoria académica';

  @override
  String get educationCredentialsDiscoverSubtitle =>
      'Obtenga su diploma digital';

  @override
  String get security => 'Seguridad';

  @override
  String get networkAndRegistries => 'Red y registros';

  @override
  String get chooseNetwork => 'Elegir red';

  @override
  String get chooseRegistry => 'Elegir registro';

  @override
  String get trustFramework => 'Marco de confianza';

  @override
  String get network => 'Red';

  @override
  String get issuerRegistry => 'Registro de emisor';

  @override
  String get termsOfUse => 'Términos de uso y confidencialidad';

  @override
  String get scanFingerprintToAuthenticate =>
      'Escanear huella dactilar para autenticarse';

  @override
  String get biometricsNotSupported => 'Biometría no compatible';

  @override
  String get deviceDoNotSupportBiometricsAuthentication =>
      'Su dispositivo no admite autenticación biométrica';

  @override
  String get biometricsEnabledMessage =>
      'Ya puede desbloquear la aplicación con sus biometría.';

  @override
  String get biometricsDisabledMessage => 'Se ha desactivado su biometría.';

  @override
  String get exportSecretKey => 'Exportar clave secreta';

  @override
  String get secretKey => 'Clave secreta';

  @override
  String get chooseNetWork => 'Elegir red';

  @override
  String get nftEmptyMessage => '¡Su galería digital está vacía!';

  @override
  String get myAccount => 'Mi cuenta';

  @override
  String get cryptoAccounts => 'Cuentas';

  @override
  String get cryptoAccount => 'Cuenta';

  @override
  String get cryptoAddAccount => 'Añadir cuenta';

  @override
  String get cryptoAddedMessage => 'Su cuenta de criptomonedas se ha añadido.';

  @override
  String get cryptoEditConfirmationDialog =>
      '¿Confirma editar el nombre de cuenta de criptomonedas?';

  @override
  String get cryptoEditConfirmationDialogYes => 'Guardar';

  @override
  String get cryptoEditConfirmationDialogNo => 'Cancelar';

  @override
  String get cryptoEditLabel => 'Nombre de cuenta';

  @override
  String get onBoardingFirstTitle =>
      'Descubra 3 ofertas web exclusivas en su cartera.';

  @override
  String get onBoardingFirstSubtitle =>
      'Obtenga tarjetas de afiliación y fidelización, vales y muchas ventajas de sus aplicaciones y juegos favoritos.';

  @override
  String get onBoardingSecondTitle =>
      'Nuestra cartera es mucho más que una cartera digital.';

  @override
  String get onBoardingSecondSubtitle =>
      'Almacene y administre datos personales y acceda a cualquier aplicación de la web 3.0.';

  @override
  String get onBoardingThirdTitle =>
      'Gestione sus datos con autonomía, seguridad y privacidad.';

  @override
  String get onBoardingThirdSubtitle =>
      'La cartera usa criptografía SSI para ofrecerle un control de datos total. Nada saldrá fuera de su teléfono.';

  @override
  String get onBoardingStart => 'Empezar';

  @override
  String get learnMoreAboutAltme => 'Descubra más sobre nuestra cartera';

  @override
  String get scroll => 'Desplazarse';

  @override
  String get agreeTermsAndConditionCheckBox =>
      'Acepto los términos y condiciones.';

  @override
  String get readTermsOfUseCheckBox => 'He leído los términos de uso.';

  @override
  String get createOrImportNewAccount => 'Crear o importar una nueva cuenta.';

  @override
  String get selectAccount => 'Seleccionar cuenta';

  @override
  String get onbordingSeedPhrase => 'Frase semilla';

  @override
  String get onboardingPleaseStoreMessage => 'Escriba su frase de recuperación';

  @override
  String get onboardingVerifyPhraseMessage =>
      'Confirmar palabras de recuperación';

  @override
  String get onboardingVerifyPhraseMessageDetails =>
      'Para comprobar que su frase de recuperación esté bien, seleccione las palabras en orden correcto.';

  @override
  String get onboardingAltmeMessage =>
      'La cartera es sin custodia. La frase de recuperación es la única forma de recuperar su cuenta.';

  @override
  String get onboardingWroteDownMessage =>
      'He escrito una frase de recuperación';

  @override
  String get copyToClipboard => 'Copiar en el portapapeles';

  @override
  String get pinCodeMessage =>
      'El código PIN impide el acceso no autorizado a su cartera. Puede cambiarlo en cualquier momento.';

  @override
  String get enterNameForYourNewAccount =>
      'Escriba un nombre para su nueva cuenta';

  @override
  String get create => 'Crear';

  @override
  String get import => 'Importar';

  @override
  String get accountName => 'Nombre de cuenta';

  @override
  String get importWalletText =>
      'Escriba aquí su frase de recuperación o clave privada.';

  @override
  String get importWalletTextRecoveryPhraseOnly =>
      'Escriba aquí su frase de recuperación.';

  @override
  String get recoveryPhraseDescriptions =>
      'Una frase de recuperación (o frase semilla, clave privada o frase de copia de respaldo) es una lista de 12 palabras generadas por su cartera de criptomonedas para acceder a sus fondos';

  @override
  String get importEasilyFrom => 'Importar su contraseña desde:';

  @override
  String get templeWallet => 'Cartera de Temple';

  @override
  String get temple => 'Temple';

  @override
  String get metaMaskWallet => 'Cartera de Metamask';

  @override
  String get metaMask => 'Metamask';

  @override
  String get kukai => 'Kukai';

  @override
  String get kukaiWallet => 'Cartera de Kukai';

  @override
  String get other => 'Otra';

  @override
  String get otherWalletApp => 'Otra aplicación de cartera';

  @override
  String importWalletHintText(Object numberCharacters) {
    return 'Tras escribir sus 12 palabras (frase de recuperación) o $numberCharacters caracteres privados (clave privada), toque Importar.';
  }

  @override
  String get importWalletHintTextRecoveryPhraseOnly =>
      'Tras escribir sus 12 palabras (frase de recuperación), toque Importar.';

  @override
  String get kycDialogTitle =>
      'Para obtener esta tarjeta y otras tarjetas de identidad, verifique su ID';

  @override
  String get idVerificationProcess => 'Proceso de verificación de ID';

  @override
  String get idCheck => 'Comprobación de ID';

  @override
  String get facialRecognition => 'Reconocimiento facial';

  @override
  String get kycDialogButton => 'Iniciar verificación de ID';

  @override
  String get kycDialogFooter =>
      'Conforme al RGPD y la CCPA + nivel de seguridad SOC2';

  @override
  String get finishedVerificationTitle => 'Verificación de ID en\ncurso';

  @override
  String get finishedVerificationDescription =>
      'Recibirá un email para confirmar que su ID se ha verificado';

  @override
  String get verificationPendingTitle =>
      'Su verificación de ID\nestá pendiente';

  @override
  String get verificationPendingDescription =>
      'En general, tarda menos de 5 minutos en verificarse. Recibirá un email una vez terminada la verificación.';

  @override
  String get verificationDeclinedTitle => 'Se ha rechazado su verificación';

  @override
  String get restartVerification => 'Reiniciar verificación de ID';

  @override
  String get verificationDeclinedDescription =>
      'Se ha rechazado su verificación. Reinicie su verificación de ID.';

  @override
  String get verifiedTitle => '¡Excelente! La verificación se ha realizado.';

  @override
  String get verifiedDescription =>
      'Ya puede empezar a añadir su tarjeta \'over18\'. Vamos a empezar.';

  @override
  String get verfiedButton => 'Añadiendo la tarjeta de más de 18 años';

  @override
  String get verifiedNotificationTitle => '¡Verificación completada!';

  @override
  String get verifiedNotificationDescription =>
      '¡Enhorabuena! Verificación realizada.';

  @override
  String get showDecentralizedID => 'Mostrar identidad descentralizada';

  @override
  String get manageDecentralizedID => 'Administrar identidad descentralizada';

  @override
  String get addressBook => 'Libreta de direcciones';

  @override
  String get home => 'Mi cartera';

  @override
  String get discover => 'Descubrir';

  @override
  String get settings => 'Configuración';

  @override
  String get privateKeyDescriptions =>
      'La clave privada es un número secreto para firmar transacciones y demostrar que es titular de una dirección de blockchain. En Tezos, las claves privadas suelen tener 54 caracteres.';

  @override
  String get importAccount => 'Importar cuenta';

  @override
  String get imported => 'Importada';

  @override
  String get cardDetails => 'Detalles de tarjeta';

  @override
  String get publicAddress => 'Dirección pública';

  @override
  String get didKey => 'Clave DID';

  @override
  String get export => 'Exportar';

  @override
  String get copy => 'Copiar';

  @override
  String get didPrivateKey => 'Clave privada DID';

  @override
  String get reveal => 'Mostrar';

  @override
  String get didPrivateKeyDescription =>
      'Tenga mucho cuidado con sus claves privadas: controlan el acceso a sus datos de credenciales.';

  @override
  String get didPrivateKeyDescriptionAlert =>
      'No comparta su clave privada con nadie. Esta cartera es sin custodia. Nunca se la pediremos.';

  @override
  String get iReadTheMessageCorrectly => 'Leo bien el mensaje';

  @override
  String get beCareful => 'Cuidado';

  @override
  String get decentralizedIDKey => 'Clave de identidad descentralizada';

  @override
  String get copySecretKeyToClipboard =>
      '¡Clave secreta copiada en el portapapeles!';

  @override
  String get copyDIDKeyToClipboard => '¡Clave DID copiada en el portapapeles!';

  @override
  String get seeAddress => 'Ver dirección';

  @override
  String get revealPrivateKey => 'Mostrar clave privada';

  @override
  String get share => 'Compartir';

  @override
  String get shareWith => 'Compartir con';

  @override
  String get copiedToClipboard => '¡Se ha copiado en el portapapeles!';

  @override
  String get privateKey => 'Clave privada';

  @override
  String get decentralizedID => 'Identificador descentralizado';

  @override
  String get did => 'DID';

  @override
  String get sameAccountNameError =>
      'Este nombre de cuenta se ha usado antes, escriba uno distinto';

  @override
  String get unknown => 'Desconocido';

  @override
  String get credentialManifestDescription => 'Descripción';

  @override
  String get credentialManifestInformations => 'Información';

  @override
  String get credentialDetailsActivity => 'Actividad';

  @override
  String get credentialDetailsOrganisation => 'Organización';

  @override
  String get credentialDetailsPresented => 'Presentado';

  @override
  String get credentialDetailsOrganisationDetail =>
      'Detalles de la organización:';

  @override
  String get credentialDetailsInWalletSince => 'En la cartera desde';

  @override
  String get termsOfUseAndLicenses => 'Términos de uso y licencias';

  @override
  String get licenses => 'Licencias';

  @override
  String get sendTo => 'Enviar a';

  @override
  String get next => 'Siguiente';

  @override
  String get withdrawalInputHint => 'Copiar dirección o escanear';

  @override
  String get amount => 'Cantidad';

  @override
  String get amountSent => 'Cantidad enviada';

  @override
  String get max => 'Máx.';

  @override
  String get edit => 'Editar';

  @override
  String get networkFee => 'Tarifa de gas estimada';

  @override
  String get totalAmount => 'Cantidad total';

  @override
  String get selectToken => 'Seleccionar token';

  @override
  String get insufficientBalance => 'Saldo insuficiente';

  @override
  String get slow => 'Lento';

  @override
  String get average => 'Medio';

  @override
  String get fast => 'Rápido';

  @override
  String get changeFee => 'Cambiar tarifa';

  @override
  String get sent => 'Enviado';

  @override
  String get done => 'Listo';

  @override
  String get link => 'Haga clic para acceder';

  @override
  String get myTokens => 'Mis tokens';

  @override
  String get tezosMainNetwork => 'Red principal de Tezos';

  @override
  String get send => 'Enviar';

  @override
  String get receive => 'Recibir';

  @override
  String get recentTransactions => 'Transacciones recientes';

  @override
  String sendOnlyToThisAddressDescription(Object symbol) {
    return 'Envíe únicamente $symbol a esta dirección. Si envía otros tokens, podría perderlos para siempre.';
  }

  @override
  String get addTokens => 'Añadir tokens';

  @override
  String get providedBy => 'Suministrado por';

  @override
  String get issuedOn => 'Emitido el';

  @override
  String get expirationDate => 'Periodo de validez';

  @override
  String get connect => 'Conectar';

  @override
  String get connection => 'Conexión';

  @override
  String get selectAccountToGrantAccess =>
      'Seleccione una cuenta para conceder acceso:';

  @override
  String get requestPersmissionTo => 'Solicitar permiso para:';

  @override
  String get viewAccountBalanceAndNFTs => 'Ver el saldo de la cuenta y los NFT';

  @override
  String get requestApprovalForTransaction =>
      'Solicitar aprobación para la transacción';

  @override
  String get connectedWithBeacon => 'Conexión con dApp realizada';

  @override
  String get failedToConnectWithBeacon => 'Error al conectar con dApp';

  @override
  String get tezosNetwork => 'Red de Tezos';

  @override
  String get confirm_sign => 'Confirmar firma';

  @override
  String get sign => 'Firmar';

  @override
  String get payload_to_sign => 'Carga para firmar';

  @override
  String get signedPayload => 'La carga se ha firmado.';

  @override
  String get failedToSignPayload => 'Error al firmar la carga';

  @override
  String get voucher => 'Vale';

  @override
  String get tezotopia => 'Tezotopia';

  @override
  String get operationCompleted =>
      'La operación solicitada ha finalizado. La transacción puede tardar unos minutos en aparecer en la cartera.';

  @override
  String get operationFailed => 'Error al realizar la operación solicitada';

  @override
  String get membership => 'Afiliación';

  @override
  String get switchNetworkMessage => 'Cambie a su red a';

  @override
  String get fee => 'Tarifa';

  @override
  String get addCards => 'Añadir tarjetas';

  @override
  String get gaming => 'Videojuegos';

  @override
  String get identity => 'Identidad';

  @override
  String get payment => 'Pago';

  @override
  String get socialMedia => 'Redes sociales';

  @override
  String get advanceSettings => 'Configuración avanzada';

  @override
  String get categories => 'Categorías';

  @override
  String get selectCredentialCategoryWhichYouWantToShowInCredentialList =>
      'Seleccione categorías de credenciales para mostrar en la lista de credenciales:';

  @override
  String get community => 'Comunidad';

  @override
  String get tezos => 'Tezos';

  @override
  String get rights => 'Derechos';

  @override
  String get disconnectAndRevokeRights => 'Desconectar y revocar derechos';

  @override
  String get revokeAllRights => 'Revocar todos los derechos';

  @override
  String get revokeSubtitleMessage =>
      '¿Seguro que desea revocar todos los derechos?';

  @override
  String get revokeAll => 'Revocar todos';

  @override
  String get succesfullyDisconnected => 'Desconexión de dApp realizada.';

  @override
  String get connectedApps => 'dApps conectadas';

  @override
  String get manageConnectedApps => 'Administrar dApps conectadas';

  @override
  String get noDappConnected => 'Aún no hay ninguna dApp conectada';

  @override
  String get nftDetails => 'Detalles de NFT';

  @override
  String get failedToDoOperation => 'Error al realizar la operación';

  @override
  String get nft => 'NFT';

  @override
  String get receiveNft => 'Recibir NFT';

  @override
  String get sendOnlyNftToThisAddressDescription =>
      'Envíe únicamente NFT de Tezos a esta dirección. Si envía NFT de otra red, podría perderlos para siempre.';

  @override
  String get beaconShareMessage =>
      'Envíe solo Tezos (XTZ) y NFT de Tezos (estándar FA2) a esta dirección. Si envía Tezos y NFT de otras redes, podría perderlos para siempre';

  @override
  String get advantagesCredentialHomeSubtitle =>
      'Disfrute de ventajas exclusivas en Web3';

  @override
  String get advantagesCredentialDiscoverSubtitle =>
      'Descubra tarjetas de fidelización y pases exclusivos';

  @override
  String get identityCredentialHomeSubtitle =>
      'Demuestre cosas sobre sí mismo protegiendo sus datos';

  @override
  String get identityCredentialDiscoverSubtitle =>
      'Reciba KYC reutilizables y credenciales de verificación de edad';

  @override
  String get myProfessionalCredentialDiscoverSubtitle =>
      'Use sus tarjetas profesionales de forma segura';

  @override
  String get blockchainAccountsCredentialHomeSubtitle =>
      'Demuestre que es titular de sus cuentas de blockchain';

  @override
  String get educationCredentialHomeSubtitle =>
      'Demuestre su trayectoria académica al instante';

  @override
  String get passCredentialHomeSubtitle =>
      'Utilice pases exclusivos: Equipe su experiencia Web3 con todo lo necesario';

  @override
  String get financeCardsCredentialHomeSubtitle =>
      'Acceda a nuevas oportunidades de inversión en Web3';

  @override
  String get financeCardsCredentialDiscoverSubtitle =>
      'Reciba ventajas exclusivas de comunidades que le gustan';

  @override
  String get contactInfoCredentialHomeSubtitle =>
      'Comparta sus datos de contacto al instante';

  @override
  String get contactInfoCredentialDiscoverSubtitle =>
      'Obtenga credenciales fáciles de compartir';

  @override
  String get otherCredentialHomeSubtitle =>
      'Otros tipos de tarjetas en su cartera';

  @override
  String get otherCredentialDiscoverSubtitle =>
      'Otros tipos de tarjetas que puede añadir';

  @override
  String get showMore => '... Mostrar más';

  @override
  String get showLess => 'Mostrar menos...';

  @override
  String get gotIt => 'De acuerdo';

  @override
  String get transactionErrorBalanceTooLow =>
      'Una operación ha intentado gastar más tokens que los del contrato';

  @override
  String get transactionErrorCannotPayStorageFee =>
      'El coste de almacenamiento supera el saldo del contrato';

  @override
  String get transactionErrorFeeTooLow => 'Costes de operación demasiado bajos';

  @override
  String get transactionErrorFeeTooLowForMempool =>
      'Costes de operación demasiado bajos para mempool lleno';

  @override
  String get transactionErrorTxRollupBalanceTooLow =>
      'Se ha intentado gastar un índice de ticket de un índice sin el saldo necesario';

  @override
  String get transactionErrorTxRollupInvalidZeroTransfer =>
      'El importe de una transferencia debe ser superior a cero.';

  @override
  String get transactionErrorTxRollupUnknownAddress =>
      'La dirección debe estar en el contexto al firmar una transferencia con ella.';

  @override
  String get transactionErrorInactiveChain =>
      'Se ha intentado validar un bloque de una cadena inactiva.';

  @override
  String get website => 'Sitio web';

  @override
  String get whyGetThisCard => 'Por qué esta tarjeta';

  @override
  String get howToGetIt => 'Cómo conseguirla';

  @override
  String get emailPassWhyGetThisCard =>
      'Prueba que pueden requerir algunas aplicaciones/sitios web 3.0 para acceder a su servicio o sus ventajas: Tarjeta de afiliación o fidelización, recompensas, etc.';

  @override
  String get emailPassExpirationDate =>
      'Esta tarjeta seguirá activa y reutilizable durante 1 AÑO.';

  @override
  String get emailPassHowToGetIt =>
      'Es realmente fácil. Altme verificará que es titular de esa dirección enviándole un código por email.';

  @override
  String get tezotopiaMembershipWhyGetThisCard =>
      'Esta tarjeta de afiliación ofrece reembolsos del 25 % en TODAS las transacciones de juegos de Tezotopia al comprar un Drops en tienda o emitir un NFT en Starbase.';

  @override
  String get tezotopiaMembershipExpirationDate =>
      'Esta tarjeta seguirá activa y reutilizable durante 1 AÑO.';

  @override
  String get tezotopiaMembershipLongDescription =>
      'Tezotopia es un juego de NFT de metaverso en tiempo real en Tezos para cosechar Tezotops, luchar por recompensas y conquistar tierras en una aventura espacial de blockchain inmersiva. Explore el metaverso, gane NFT y conquiste Tezotopia.';

  @override
  String get chainbornMembershipHowToGetIt =>
      'Para obtener esta tarjeta, necesita un “Héroe” en Chainborn y una prueba de email. La tarjeta “Prueba de email” está en la sección “Discover” de Altme.';

  @override
  String get chainbornMembershipWhyGetThisCard =>
      '¡Acceda en primicia a contenido exclusivo de la tienda, airdrops y más ventajas solo para miembros de Chainborn!';

  @override
  String get chainbornMembershipExpirationDate =>
      'Esta tarjeta seguirá activa y reutilizable durante 1 AÑO.';

  @override
  String get chainbornMembershipLongDescription =>
      'Chainborn es un juego de lucha de NFT. Use sus propios NFT como héroes y compita por botines y la gloria. Luche, gane puntos de experiencia para mejorar la fuerza y salud de su héroe y aumente el valor de sus NFT en esta cautivadora aventura en Tezos.';

  @override
  String get twitterHowToGetIt =>
      'Siga los pasos en TezosProfiles https://tzprofiles.com/connect. A continuación, solicite la tarjeta “Cuenta de Twitter” en Altme. Asegúrese de firmar la transacción en TZPROFILES con la misma cuenta que usa en Altme.';

  @override
  String get twitterWhyGetThisCard =>
      'La tarjeta demuestra que es titular de su cuenta de Twitter. Úsela siempre que tenga que demostrar que es titular de su cuenta de Twitter.';

  @override
  String get twitterExpirationDate =>
      'Esta tarjeta seguirá activa durante 1 año.';

  @override
  String get twitterDummyDesc =>
      'Demuestre que es titular de su cuenta de Twitter.';

  @override
  String get tezotopiaMembershipHowToGetIt =>
      'Debe presentar una prueba de que es mayor de 13 años y otra para su email.';

  @override
  String get over18WhyGetThisCard =>
      'Prueba que pueden requerir algunas aplicaciones/sitios web 3.0 para acceder a su servicio o sus ventajas: Tarjeta de afiliación o fidelización, recompensas, etc.';

  @override
  String get over18ExpirationDate =>
      'Esta tarjeta seguirá activa y reutilizable durante 1 AÑO.';

  @override
  String get over18HowToGetIt =>
      'Puede solicitar esta tarjeta tras la verificación KYC de Altme.';

  @override
  String get over13WhyGetThisCard =>
      'Prueba que pueden requerir algunas aplicaciones/sitios web 3.0 para acceder a su servicio o sus ventajas: Tarjeta de afiliación o fidelización, recompensas, etc.';

  @override
  String get over13ExpirationDate =>
      'Esta tarjeta seguirá activa y reutilizable durante 1 AÑO.';

  @override
  String get over13HowToGetIt =>
      'Puede solicitar esta tarjeta tras la verificación KYC de Altme.';

  @override
  String get over15WhyGetThisCard =>
      'Prueba que pueden requerir algunas aplicaciones/sitios web 3.0 para acceder a su servicio o sus ventajas: Tarjeta de afiliación o fidelización, recompensas, etc.';

  @override
  String get over15ExpirationDate =>
      'Esta tarjeta seguirá activa y reutilizable durante 1 AÑO.';

  @override
  String get over15HowToGetIt =>
      'Puede solicitar esta tarjeta tras la verificación KYC de Altme.';

  @override
  String get passportFootprintWhyGetThisCard =>
      'Prueba que pueden requerir algunas aplicaciones/sitios web 3.0 para acceder a su servicio o sus ventajas: Tarjeta de afiliación o fidelización, recompensas, etc.';

  @override
  String get passportFootprintExpirationDate =>
      'Esta tarjeta seguirá activa y reutilizable durante 1 AÑO.';

  @override
  String get passportFootprintHowToGetIt =>
      'Puede solicitar esta tarjeta tras la verificación KYC de Altme.';

  @override
  String get verifiableIdCardWhyGetThisCard =>
      'Esta tarjeta de identidad digital contiene la misma información que su carné de identidad físico. Ej.: Puede usarla en Web 3 para una verificación KYC.';

  @override
  String get verifiableIdCardExpirationDate =>
      'Esta tarjeta seguirá activa y reutilizable durante 1 AÑO.';

  @override
  String get verifiableIdCardHowToGetIt =>
      'Puede solicitar esta tarjeta tras la verificación KYC de Altme.';

  @override
  String get verifiableIdCardDummyDesc =>
      'Consiga su documento de identidad digital.';

  @override
  String get phoneProofWhyGetThisCard =>
      'Prueba que pueden requerir algunas aplicaciones/sitios web 3.0 para acceder a su servicio o sus ventajas: Tarjeta de afiliación o fidelización, recompensas, etc.';

  @override
  String get phoneProofExpirationDate =>
      'Esta tarjeta seguirá activa y reutilizable durante 1 AÑO.';

  @override
  String get phoneProofHowToGetIt =>
      'Es realmente fácil. Altme verificará que es titular de ese n.º de teléfono con un código por sms.';

  @override
  String get tezVoucherWhyGetThisCard =>
      'La tarjeta de vales le ofrece reembolsos del 10 % en TODAS las transacciones de juegos de Tezotopia al comprar un Drops en tienda o emitir un NFT en Starbase.';

  @override
  String get tezVoucherExpirationDate =>
      'Esta tarjeta seguirá activa y reutilizable durante 30 días.';

  @override
  String get tezVoucherHowToGetIt =>
      ' Es realmente fácil. Puede solicitarla gratis ahora.';

  @override
  String get genderWhyGetThisCard =>
      'Esta prueba de género demuestra su género (masculino/femenino) sin revelar ningún dato personal más. Puede usarse en una encuesta de usuario, etc.';

  @override
  String get genderExpirationDate =>
      'Esta tarjeta seguirá activa y reutilizable durante 1 AÑO.';

  @override
  String get genderHowToGetIt =>
      'Puede solicitar esta tarjeta tras la verificación KYC de Altme.';

  @override
  String get nationalityWhyGetThisCard =>
      'Esta credencial es útil para demostrar su nacionalidad sin revelar ningún dato personal más. Pueden requerirla aplicaciones Web 3 en encuesta de usuario, etc.';

  @override
  String get nationalityExpirationDate =>
      'Esta tarjeta seguirá activa y reutilizable durante 1 AÑO.';

  @override
  String get nationalityHowToGetIt =>
      'Puede solicitar esta tarjeta tras la verificación KYC de Altme.';

  @override
  String get ageRangeWhyGetThisCard =>
      'Esta credencial demuestra su grupo de edad sin revelar ningún dato personal más. Pueden requerirla aplicaciones Web 3 en encuesta de usuario para solicitar ventajas: Tarjeta de afiliación, etc.';

  @override
  String get ageRangeExpirationDate =>
      'Esta tarjeta seguirá activa y reutilizable durante 1 AÑO.';

  @override
  String get ageRangeHowToGetIt =>
      'Puede solicitar esta tarjeta tras la verificación KYC de Altme.';

  @override
  String get defiComplianceWhyGetThisCard =>
      'Obtenga pruebas verificables de cumplimiento de KYC/AML para protocolos DeFi y dApps Web 3 conformes. Tras su obtención, puede emitir un NFT intransferible y que proteja la privacidad para verificación en cadena sin revelar datos personales.';

  @override
  String get defiComplianceExpirationDate =>
      'Esta credencial sigue activa durante 3 meses. La renovación requiere una verificación de cumplimiento sencilla, sin un nuevo KYC.';

  @override
  String get defiComplianceHowToGetIt =>
      '¡Es fácil! Haga una verificación KYC única en la cartera de Altme (ID360) y solicite su credencial de cumplimiento DeFi.';

  @override
  String get origin => 'Origen';

  @override
  String get nftTooBigToLoad => 'El NFT es demasiado grande para cargarse';

  @override
  String get seeTransaction => 'Ver transacción';

  @override
  String get nftListSubtitle =>
      'Estos son todos los NFT y coleccionables de su cuenta.';

  @override
  String get tokenListSubtitle => 'Estos son todos los tokens de su cuenta.';

  @override
  String get my => 'Mi';

  @override
  String get get => 'Obtener';

  @override
  String get seeMoreNFTInformationOn => 'Ver más información de NFT sobre';

  @override
  String get credentialStatus => 'Estado';

  @override
  String get pass => 'Pase';

  @override
  String get payloadFormatErrorMessage => 'El formato de carga es incorrecto.';

  @override
  String get thisFeatureIsNotSupportedMessage =>
      'La función no es compatible aún';

  @override
  String get myWallet => 'Mi cartera';

  @override
  String get ethereumNetwork => 'Red Ethereum';

  @override
  String get fantomNetwork => 'Red Fantom';

  @override
  String get polygonNetwork => 'Red Polygon';

  @override
  String get binanceNetwork => 'Red BNB Chain';

  @override
  String get step => 'Paso';

  @override
  String get activateBiometricsTitle =>
      'Activar biometría\npara añadir una capa de seguridad';

  @override
  String get loginWithBiometricsOnBoarding => 'Iniciar sesión con biometría';

  @override
  String get option => 'Opción';

  @override
  String get start => 'Empezar';

  @override
  String get iAgreeToThe => 'Acepto los ';

  @override
  String get termsAndConditions => 'Términos y condiciones';

  @override
  String get walletReadyTitle => '¡Su cartera está lista!';

  @override
  String get walletReadySubtitle =>
      'Vamos a descubrir todo lo que \nofrece la Web 3.';

  @override
  String get failedToInitCamera => '¡Error al inicializar la cámara!';

  @override
  String get chooseMethodPageOver18Title =>
      'Elija un método para obtener su prueba Mayor de 18 años';

  @override
  String get chooseMethodPageOver13Title =>
      'Elija un método para obtener su prueba Mayor de 13 años';

  @override
  String get chooseMethodPageOver15Title =>
      'Elija un método para obtener su prueba Mayor de 15 años';

  @override
  String get chooseMethodPageOver21Title =>
      'Elija un método para obtener su prueba Mayor de 21 años';

  @override
  String get chooseMethodPageOver50Title =>
      'Elija un método para obtener su prueba Mayor de 50 años';

  @override
  String get chooseMethodPageOver65Title =>
      'Elija un método para obtener su prueba Mayor de 65 años';

  @override
  String get chooseMethodPageAgeRangeTitle =>
      'Elija un método para obtener su prueba de grupo de edad';

  @override
  String get chooseMethodPageVerifiableIdTitle =>
      'Elija un método para obtener su prueba de ID verificable';

  @override
  String get chooseMethodPageDefiComplianceTitle =>
      'Elija un método para obtener su prueba de cumplimiento DeFi';

  @override
  String get chooseMethodPageSubtitle =>
      'Verifíquese con una foto en tiempo real o una comprobación de carné de identidad clásica.';

  @override
  String get kycTitle => 'Foto rápida personal (1 min)';

  @override
  String get kycSubtitle => 'Verifíquese al instante con una foto.';

  @override
  String get passbaseTitle => 'Comprobación de carné de identidad completa';

  @override
  String get passbaseSubtitle =>
      'Verifíquese con el pasaporte o su carné de identidad o de conducir';

  @override
  String get verifyYourAge => 'Verifique su edad';

  @override
  String get verifyYourAgeSubtitle =>
      'Este proceso de verificación de edad es muy sencillo. Solo necesita una foto en tiempo real.';

  @override
  String get verifyYourAgeDescription =>
      'Al aceptar, nos autoriza a usar una imagen para estimar su edad. Nuestro socio Yoti hará la estimación. Solo usará su imagen para ello y la eliminará justo después.\n\nPara descubrir más, lea nuestra Política de privacidad.';

  @override
  String get accept => 'Aceptar';

  @override
  String get decline => 'Rechazar';

  @override
  String get yotiCameraAppbarTitle => 'Sitúe el rostro en el centro.';

  @override
  String get cameraSubtitle =>
      'Tiene 5 segundos para hacerse la foto.\nAntes de comenzar, asegúrese de que hay suficiente luz.';

  @override
  String get walletSecurityDescription =>
      'Proteja su cartera con código PIN y autenticación biométrica';

  @override
  String get blockchainSettings => 'Configuración de blockchain';

  @override
  String get blockchainSettingsDescription =>
      'Administrar cuentas, frase de recuperación, dApps y redes conectadas';

  @override
  String get ssi => 'Identidad autosoberana (DID)';

  @override
  String get ssiDescription =>
      'Gestione su identidad descentralizada, haga una copia de respaldo o restablezca sus credenciales';

  @override
  String get helpCenter => 'Centro de ayuda';

  @override
  String get helpCenterDescription =>
      'Contacte con nosotros y solicite ayuda para nuestra cartera si lo necesita';

  @override
  String get about => 'Acerca de';

  @override
  String get aboutDescription =>
      'Lea sobre términos de uso, confidencialidad y licencias';

  @override
  String get resetWallet => 'Restablecer Cartera';

  @override
  String get resetWalletDescription =>
      'Borre todos los datos de su teléfono y reinicie su cartera.';

  @override
  String get showWalletRecoveryPhrase =>
      'Mostrar frase de recuperación de cartera';

  @override
  String get showWalletRecoveryPhraseSubtitle =>
      'La frase de recuperación sirve de clave de copia de respaldo para recuperar el acceso a su cartera.';

  @override
  String get blockchainNetwork => 'Red de blockchain (de forma predeterminada)';

  @override
  String get contactUs => 'Póngase en contacto con nosotros';

  @override
  String get officialWebsite => 'Sitio web oficial';

  @override
  String get yourAppVersion => 'Su versión de la aplicación';

  @override
  String get resetWalletTitle => '¿Seguro que desea restablecer su cartera?';

  @override
  String get resetWalletSubtitle =>
      'A hacerlo, se borrarán todos sus datos. Guarde su frase de recuperación y el archivo de copia de respaldo de credenciales antes de eliminar.';

  @override
  String get resetWalletSubtitle2 =>
      'Esta cartera es de autocustodia; no podemos recuperar sus fondos o credenciales por usted.';

  @override
  String get resetWalletCheckBox1 => 'He escrito una frase de recuperación';

  @override
  String get resetWalletCheckBox2 =>
      'Guardé el archivo de copia de respaldo de credenciales';

  @override
  String get email => 'Email';

  @override
  String get fillingThisFieldIsMandatory =>
      'Es obligatorio rellenar este campo.';

  @override
  String get yourMessage => 'Su mensaje';

  @override
  String get message => 'Mensaje';

  @override
  String get subject => 'Asunto';

  @override
  String get enterAValidEmail => 'Escriba un email válido.';

  @override
  String get failedToSendEmail => 'Error al enviar el email.';

  @override
  String get selectAMethodToAddAccount =>
      'Seleccione un método para añadir la cuenta';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get createAccountDescription =>
      'Crear una cuenta protegida por su frase de recuperación';

  @override
  String get importAccountDescription =>
      'Importar una cuenta desde una cartera existente';

  @override
  String get chooseABlockchainForAccountCreation =>
      'Elija la blockchain en la que desea crear una nueva cuenta.';

  @override
  String get tezosAccount => 'Cuenta de Tezos';

  @override
  String get tezosAccountDescription =>
      'Crear una nueva dirección de blockchain de Tezos';

  @override
  String get ethereumAccount => 'Cuenta de Ethereum';

  @override
  String get ethereumAccountDescription =>
      'Crear una nueva dirección de blockchain de Ethereum';

  @override
  String get fantomAccount => 'Cuenta de Fantom';

  @override
  String get fantomAccountDescription =>
      'Crear una nueva dirección de blockchain de Fantom';

  @override
  String get polygonAccount => 'Cuenta de Polygon';

  @override
  String get polygonAccountDescription =>
      'Crear una nueva dirección de blockchain de Polygon';

  @override
  String get binanceAccount => 'Cuenta de BNB Chain';

  @override
  String get binanceAccountDescription =>
      'Crear una nueva dirección de blockchain de BNB Chain';

  @override
  String get setAccountNameDescription =>
      '¿Quiere ponerle un nombre a esta nueva cuenta? Esto resulta útil si tiene varias.';

  @override
  String get letsGo => '¡Vamos allá!';

  @override
  String get congratulations => '¡Enhorabuena!';

  @override
  String get tezosAccountCreationCongratulations =>
      'Su nueva cuenta de Tezos se ha creado.';

  @override
  String get ethereumAccountCreationCongratulations =>
      'Su nueva cuenta de Ethereum se ha creado.';

  @override
  String get fantomAccountCreationCongratulations =>
      'Su nueva cuenta de Fantom se ha creado.';

  @override
  String get polygonAccountCreationCongratulations =>
      'Su nueva cuenta de Polygon se ha creado.';

  @override
  String get binanceAccountCreationCongratulations =>
      'Su nueva cuenta de BNB Chain se ha creado.';

  @override
  String get accountImportCongratulations => 'Su cuenta se ha importado.';

  @override
  String get saveBackupCredentialTitle =>
      'Descargue el archivo de copia de respaldo.\nGuárdelo en un lugar seguro.';

  @override
  String get saveBackupCredentialSubtitle =>
      'Para recuperar todas sus credenciales, necesita la frase de recuperación Y este archivo de copia de respaldo.';

  @override
  String get saveBackupPolygonCredentialSubtitle =>
      'Para recuperar todas sus credenciales de Polygon ID, necesita la frase de recuperación Y el archivo de copia de respaldo.';

  @override
  String get restoreCredentialStep1Title =>
      'Paso 1: Escriba las 12 palabras de su frase de recuperación';

  @override
  String get restorePhraseTextFieldHint =>
      'Escriba su frase de recuperación (o frase mnemotécnica)...';

  @override
  String get restoreCredentialStep2Title =>
      'Paso 2: Cargue su archivo de copia de respaldo de credenciales';

  @override
  String get loadFile => 'Cargar archivo';

  @override
  String get uploadFile => 'Cargar archivo';

  @override
  String get creators => 'Creadores';

  @override
  String get publishers => 'Editores';

  @override
  String get creationDate => 'Fecha de creación';

  @override
  String get myProfessionalrCards => 'tarjetas profesionales';

  @override
  String get myProfessionalrCardsSubtitle =>
      'Use sus tarjetas profesionales de forma segura.';

  @override
  String get guardaWallet => 'Cartera Guarda';

  @override
  String get exodusWallet => 'Cartera Exodus';

  @override
  String get trustWallet => 'Cartera Trust';

  @override
  String get myetherwallet => 'Cartera MyEther';

  @override
  String get skip => 'Omitir';

  @override
  String get userNotFitErrorMessage =>
      'No puede obtener esta tarjeta: no se cumplen algunas condiciones.';

  @override
  String get youAreMissing => 'Le faltan';

  @override
  String get credentialsRequestedBy => 'credenciales solicitadas por';

  @override
  String get transactionIsLikelyToFail =>
      'Es probable que falle la transacción.';

  @override
  String get buy => 'Comprar';

  @override
  String get thisFeatureIsNotSupportedYetForFantom =>
      'Esta función no es compatible aún para Fantom.';

  @override
  String get faqs => 'Preguntas frecuentes (P+F)';

  @override
  String get softwareLicenses => 'Licencias de software';

  @override
  String get notAValidWalletAddress =>
      '¡No es una dirección de cartera válida!';

  @override
  String get otherAccount => 'Otra cuenta';

  @override
  String get thereIsNoAccountInYourWallet =>
      'No hay ninguna cuenta en su cartera';

  @override
  String get credentialSuccessfullyExported => 'Su credencial se ha exportado.';

  @override
  String get scanAndDisplay => 'Escanear y mostrar';

  @override
  String get whatsNew => 'Novedades';

  @override
  String get okGotIt => '¡DE ACUERDO!';

  @override
  String get support => 'asistencia';

  @override
  String get transactionDoneDialogDescription =>
      'La transferencia puede tardar unos minutos en realizarse';

  @override
  String get withdrawalFailedMessage =>
      'No ha sido posible efectuar la retirada de la cuenta';

  @override
  String get credentialRequiredMessage =>
      'Necesita esas credenciales en su cartera para adquirir esta tarjeta:';

  @override
  String get keyDecentralizedIdEdSA =>
      'Identidad descentralizada de llave EdDSA';

  @override
  String get keyDecentralizedIDSecp256k1 =>
      'Identidad descentralizada de llave Secp256k1';

  @override
  String get ebsiV3DecentralizedId => 'Identidad descentralizada de EBSI V3';

  @override
  String get requiredCredentialNotFoundTitle =>
      'No se encuentra la credencial\nque necesita en su cartera.';

  @override
  String get requiredCredentialNotFoundSubTitle =>
      'La credencial requerida no está en su cartera';

  @override
  String get requiredCredentialNotFoundDescription =>
      'Póngase en contacto con nosotros en:';

  @override
  String get backToHome => 'Volver al inicio';

  @override
  String get help => 'Ayuda';

  @override
  String get searchCredentials => 'Buscar credenciales';

  @override
  String get supportChatWelcomeMessage =>
      '¡Bienvenido/a a nuestra asistencia por chat! Estamos aquí para ayudarle con cualquier duda o problema sobre nuestra cartera.';

  @override
  String get cardChatWelcomeMessage =>
      '¡Bienvenido/a a nuestra asistencia por chat! Estamos aquí para ayudarle con cualquier duda o problema.';

  @override
  String get creator => 'Creador';

  @override
  String get contractAddress => 'Dirección de contrato';

  @override
  String get lastMetadataSync => 'Última sincronización de metadatos';

  @override
  String get e2eEncyptedChat => 'El chat está cifrado de extremo a extremo.';

  @override
  String get pincodeAttemptMessage =>
      'Ha introducido un código PIN incorrecto tres veces. Por motivos de seguridad, espere un minuto antes de volverlo a intentar.';

  @override
  String get verifyNow => 'Verificar ahora';

  @override
  String get verifyLater => 'Verificar más tarde';

  @override
  String get welDone => '¡Excelente!';

  @override
  String get mnemonicsVerifiedMessage =>
      'Su frase de recuperación se ha guardado.';

  @override
  String get chatWith => 'Chatear con';

  @override
  String get sendAnEmail => 'Enviar un email';

  @override
  String get livenessCardHowToGetIt =>
      '¡Es fácil! Haga una verificación KYC única en la cartera de Altme (ID360) y solicite su credencial de Liveness.';

  @override
  String get livenessCardExpirationDate =>
      'Esta credencial seguirá activa durante 1 año. La renovación es sencilla.';

  @override
  String get livenessCardWhyGetThisCard =>
      'Obtenga pruebas verificables de humanidad para la mayoría de DeFi, protocolos GameFi y dApps Web3. Tras su obtención, puede emitir un NFT intransferible y que proteja la privacidad para verificación en cadena sin revelar datos personales.';

  @override
  String get livenessCardLongDescription =>
      'La credencial es una prueba verificable de humanidad. Permite demostrar que no es un bot en protocolos DeFi, juegos en cadena o dApps Web3.';

  @override
  String get chat => 'Chatear';

  @override
  String get needMnemonicVerificatinoDescription =>
      '¡Verifique las frases semilla de su cartera para proteger sus activos!';

  @override
  String get succesfullyAuthenticated => 'Se ha autenticado.';

  @override
  String get authenticationFailed => 'Error al autenticar.';

  @override
  String get documentType => 'Tipo de documento';

  @override
  String get countryCode => 'Código de país';

  @override
  String get deviceIncompatibilityMessage =>
      'Su dispositivo no es compatible con esta función.';

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
  String get yearsOld => 'años';

  @override
  String get youAreOver13 => 'Tiene más de 13 años';

  @override
  String get youAreOver15 => 'Tiene más de 15 años';

  @override
  String get youAreOver18 => 'Tiene más de 18 años';

  @override
  String get youAreOver21 => 'Tiene más de 21 años';

  @override
  String get youAreOver50 => 'Tiene más de 50 años';

  @override
  String get youAreOver65 => 'Tiene más de 65 años';

  @override
  String get polygon => 'Polygon';

  @override
  String get ebsi => 'EBSI';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get financeCredentialsHomeTitle => 'Mis credenciales financieras';

  @override
  String get financeCredentialsDiscoverTitle =>
      'Obtener credenciales financieras verificadas';

  @override
  String get financeCredentialsDiscoverSubtitle =>
      'Acceda a nuevas oportunidades de inversión en web3.';

  @override
  String get financeCredentialsHomeSubtitle =>
      'Acceda a nuevas oportunidades de inversión en Web3';

  @override
  String get hummanityProofCredentialsHomeTitle => 'Mi prueba de humanidad';

  @override
  String get hummanityProofCredentialsHomeSubtitle =>
      'Demuestra fácilmente que es un humano y no un bot.';

  @override
  String get hummanityProofCredentialsDiscoverTitle =>
      'Demuestre que no es un bot ni una IA';

  @override
  String get hummanityProofCredentialsDiscoverSubtitle =>
      'Obtenga una prueba de humanidad reutilizable para compartir';

  @override
  String get socialMediaCredentialsHomeTitle => 'Mis cuentas de redes sociales';

  @override
  String get socialMediaCredentialsHomeSubtitle =>
      'Demuestre titularidad al instante en sus cuentas con la prueba de humanidad';

  @override
  String get socialMediaCredentialsDiscoverTitle =>
      'Verificar sus cuentas de redes sociales';

  @override
  String get socialMediaCredentialsDiscoverSubtitle =>
      'Demuestre titularidad al instante en sus cuentas cuando lo necesite';

  @override
  String get walletIntegrityCredentialsHomeTitle => 'Integridad de cartera';

  @override
  String get walletIntegrityCredentialsHomeSubtitle => 'TBD';

  @override
  String get walletIntegrityCredentialsDiscoverTitle => 'Integridad de cartera';

  @override
  String get walletIntegrityCredentialsDiscoverSubtitle => 'TBD';

  @override
  String get polygonCredentialsHomeSubtitle =>
      'Demuestre derechos de acceso en ecosistema de Polygon';

  @override
  String get polygonCredentialsDiscoverSubtitle =>
      'Demuestre derechos de acceso en ecosistema de Polygon';

  @override
  String get pendingCredentialsHomeTitle => 'Mis credenciales pendientes';

  @override
  String get pendingCredentialsHomeSubtitle =>
      'Demuestre sus derechos de acceso.';

  @override
  String get restore => 'Restablecer';

  @override
  String get backup => 'Hacer una copia de respaldo';

  @override
  String get takePicture => 'Hacer una foto';

  @override
  String get kyc => 'KYC';

  @override
  String get aiSystemWasNotAbleToEstimateYourAge =>
      'El sistema de IA no pudo estimar su edad';

  @override
  String youGotAgeCredentials(Object credential) {
    return 'Ha obtenido su credencial $credential.';
  }

  @override
  String yourAgeEstimationIs(Object ageEstimate) {
    return 'La estimación de su edad de IA es $ageEstimate años';
  }

  @override
  String get credentialNotFound => 'Credencial no encontrada';

  @override
  String get cryptographicProof => 'Prueba criptográfica';

  @override
  String get downloadingCircuitLoadingMessage =>
      'Descargando circuitos. Esto puede tardar un poco. Espere.';

  @override
  String get cryptoAccountAlreadyExistMessage =>
      'Parece haber una cuenta con esta información criptográfica';

  @override
  String get errorGeneratingProof => 'Error al generar la prueba';

  @override
  String get createWalletMessage => 'Primero cree su cartera.';

  @override
  String get successfullyGeneratingProof => 'Prueba generada';

  @override
  String get wouldYouLikeToAcceptThisCredentialsFromThisOrganisation =>
      '¿Desea aceptar esta(s) credencial(es) de esta organización?';

  @override
  String get thisOrganisationRequestsThisInformation =>
      'Esta organización solicita';

  @override
  String get iS => 'es';

  @override
  String get isSmallerThan => 'es menor que';

  @override
  String get isBiggerThan => 'es mayor que';

  @override
  String get isOneOfTheFollowingValues => 'es uno de los siguientes valores';

  @override
  String get isNotOneOfTheFollowingValues =>
      'no es uno de los siguientes valores';

  @override
  String get isNot => 'no es';

  @override
  String get approve => 'Aprobar';

  @override
  String get noInformationWillBeSharedFromThisCredentialMessage =>
      'No se compartirá información de esta credencial (Prueba de Conocimiento Cero).';

  @override
  String get burn => 'Retirar';

  @override
  String get wouldYouLikeToConfirmThatYouIntendToBurnThisNFT =>
      '¿Seguro que desea retirar este NFT?';

  @override
  String pleaseAddXtoConnectToTheDapp(Object chain) {
    return 'Añada la cuenta $chain para conectarse a la dApp.';
  }

  @override
  String pleaseSwitchPolygonNetwork(Object networkType) {
    return 'Cambie a $networkType de Polygon para ejecutar esta acción.';
  }

  @override
  String get oidc4vcProfile => 'Perfil de OIDC4VC';

  @override
  String get pleaseSwitchToCorrectOIDC4VCProfile =>
      'Cambie al perfil de OIDC4VC correcto.';

  @override
  String get authenticationSuccess => 'Autenticación correcta';

  @override
  String get format => 'Formato';

  @override
  String get verifyIssuerWebsiteIdentity =>
      'Verificar la identidad del sitio web del emisor';

  @override
  String get verifyIssuerWebsiteIdentitySubtitle =>
      'Predeterminado: Desactivado\nActívelo para verificar la identidad del sitio web antes de acceder.';

  @override
  String get developerMode => 'Modo de desarrollador';

  @override
  String get developerModeSubtitle =>
      'Active el modo de desarrollador para depuración avanzada';

  @override
  String get confirmVerifierAccess => 'Confirmar acceso de verificador';

  @override
  String get confirmVerifierAccessSubtitle =>
      'Predeterminado: Activado\nDesactívelo para omitir la confirmación al compartir credenciales verificables.';

  @override
  String get secureAuthenticationWithPINCode =>
      'Proteger autenticación con código PIN';

  @override
  String get secureAuthenticationWithPINCodeSubtitle =>
      'Predeterminado: Activado\nDesactívelo para omitir código PIN para autenticación del sitio web (no recomendado).';

  @override
  String youcanSelectOnlyXCredential(Object count) {
    return 'Solo puede seleccionar $count credencial(es).';
  }

  @override
  String get theCredentialIsNotReady => 'La credencial no está lista.';

  @override
  String get theCredentialIsNoMoreReady =>
      'La credencial ya no está disponible.';

  @override
  String get lowSecurity => 'Seguridad baja';

  @override
  String get highSecurity => 'Seguridad alta';

  @override
  String get theRequestIsRejected => 'Se ha rechazado la solicitud.';

  @override
  String get userPinIsIncorrect => 'El PIN de usuario es incorrecto';

  @override
  String get security_level => 'Nivel de seguridad';

  @override
  String get userPinTitle =>
      'Flujo de dígitos del PIN de usuario pre-authorized_code';

  @override
  String get userPinSubtitle =>
      'Predeterminado: 6 dígitos\nActivar para administrar el código PIN de 4 dígitos';

  @override
  String get responseTypeNotSupported =>
      'El tipo de respuesta no es compatible';

  @override
  String get invalidRequest => 'La solicitud no es válida';

  @override
  String get subjectSyntaxTypeNotSupported =>
      'El tipo de sintaxis de sujeto no es compatible.';

  @override
  String get accessDenied => 'Acceso rechazado';

  @override
  String get thisRequestIsNotSupported => 'Esta solicitud no es compatible';

  @override
  String get unsupportedCredential => 'Credencial no compatible';

  @override
  String get aloginIsRequired => 'Nombre de usuario requerido';

  @override
  String get userConsentIsRequired => 'Consentimiento de usuario requerido';

  @override
  String get theWalletIsNotRegistered => 'La cartera no está registrada';

  @override
  String get credentialIssuanceDenied => 'Emisión de credencial rechazada';

  @override
  String get thisCredentialFormatIsNotSupported =>
      'Formato de credencial no compatible';

  @override
  String get thisFormatIsNotSupported => 'Formato no compatible';

  @override
  String get moreDetails => 'Más detalles';

  @override
  String get theCredentialOfferIsInvalid =>
      'La oferta de credencial no es válida';

  @override
  String get dateOfRequest => 'Fecha de solicitud';

  @override
  String get keyDecentralizedIDP256 =>
      'Identidad descentralizada de llave P-256';

  @override
  String get jwkDecentralizedIDP256 => 'Identidad descentralizada de JWK P-256';

  @override
  String get defaultDid => 'DID predeterminado';

  @override
  String get selectOneOfTheDid => 'Seleccione uno de los DID';

  @override
  String get theServiceIsNotAvailable => 'Este servicio no está disponible';

  @override
  String get issuerDID => 'DID de emisor';

  @override
  String get subjectDID => 'DID de sujeto';

  @override
  String get type => 'Tipo';

  @override
  String get credentialExpired => 'Credencial caducada';

  @override
  String get incorrectSignature => 'Firma incorrecta';

  @override
  String get revokedOrSuspendedCredential => 'Credencial revocada o suspendida';

  @override
  String get display => 'Mostrar';

  @override
  String get download => 'Descargar';

  @override
  String get successfullyDownloaded => 'Descarga correcta';

  @override
  String get advancedSecuritySettings => 'Configuración de seguridad avanzada';

  @override
  String get theIssuanceOfThisCredentialIsPending =>
      'Emisión de credencial pendiente';

  @override
  String get clientId => 'ID de cliente';

  @override
  String get clientSecret => 'Secreto de cliente';

  @override
  String get walletProfiles => 'Perfiles de cartera';

  @override
  String get walletProfilesDescription =>
      'Elija su perfil SSI o personalice el suyo propio';

  @override
  String get protectYourWallet => 'Proteja su cartera';

  @override
  String get protectYourWalletMessage =>
      'Proteja y desbloquee su cartera con su huella dactilar, rostro o el PIN de su dispositivo. Datos cifrados de forma segura en este dispositivo.';

  @override
  String get pinUnlock => 'Desbloqueo con PIN';

  @override
  String get secureWithDevicePINOnly =>
      'Proteger solo con el PIN del dispositivo';

  @override
  String get biometricUnlock => 'Desbloqueo con biometría';

  @override
  String get secureWithFingerprint => 'Proteger con huella dactilar';

  @override
  String get pinUnlockAndBiometric2FA => 'Desbloqueo con PIN + biometría (2FA)';

  @override
  String get secureWithFingerprintAndPINBackup =>
      'Proteger con huella dactilar y copia de respaldo PIN';

  @override
  String get secureYourWalletWithPINCodeAndBiometrics =>
      'Proteger su cartera con código PIN y biometría';

  @override
  String get twoFactorAuthenticationHasBeenEnabled =>
      'Autenticación en dos pasos activada.';

  @override
  String get initialization => 'Inicialización';

  @override
  String get login => 'Nombre de usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get pleaseEnterYourEmailAndYourCompanyPasswordToCreateYourAccount =>
      'Escriba su email y la contraseña de su empresa para crear su cuenta';

  @override
  String get enterTheSecurityCodeThatWeSentYouByEmail =>
      'Escriba el código de seguridad que le enviamos por email';

  @override
  String get enterTheSecurityCode => 'Escriba el código de seguridad';

  @override
  String get yourEmail => 'Su email';

  @override
  String get publicKeyOfWalletInstance =>
      'Clave pública de instancia de cartera';

  @override
  String get walletInstanceKey => 'Clave de instancia de cartera';

  @override
  String get organizationProfile => 'Perfil de organización';

  @override
  String get profileName => 'Nombre de perfil';

  @override
  String get companyName => 'Nombre de la empresa';

  @override
  String get configFileIdentifier =>
      'Identificador de archivo de configuración';

  @override
  String get updateYourWalletConfigNow =>
      'Actualizar la configuración de cartera ahora';

  @override
  String get updateConfigurationNow => 'Actualizar la configuración ahora';

  @override
  String get pleaseEnterYourEmailAndPasswordToUpdateYourOrganizationWalletConfiguration =>
      'Escriba su email y contraseña para actualizar la configuración de cartera de su organización';

  @override
  String get congrats => '¡Enhorabuena!';

  @override
  String get yourWalletConfigurationHasBeenSuccessfullyUpdated =>
      'Configuración de cartera actualizada';

  @override
  String get continueString => 'Continuar';

  @override
  String get walletProvider => 'Proveedor de cartera';

  @override
  String get clientTypeSubtitle =>
      'Predeterminado: DID\nDesplace para cambiar el tipo de cliente';

  @override
  String get thisTypeProofCannotBeUsedWithThisVCFormat =>
      'Este tipo de prueba no se puede utilizar con este formato de CV.';

  @override
  String get blockchainCardsDiscoverTitle =>
      'Obtener prueba de propiedad de cuenta cripto';

  @override
  String get blockchainCardsDiscoverSubtitle =>
      'Obtener prueba de propiedad de cuenta de criptoactivos';

  @override
  String get successfullyAddedEnterpriseAccount =>
      '¡Cuenta de Organización/Empresa añadida con éxito!';

  @override
  String get successfullyUpdatedEnterpriseAccount =>
      '¡Cuenta de Organiza ción/Empresa actualizada con éxito!';

  @override
  String get thisWalleIsAlreadyConfigured =>
      'Esta cartera digital ya está configurada';

  @override
  String get walletSettings => 'Configuración de la cartera digital';

  @override
  String get walletSettingsDescription => 'Elige tu idioma';

  @override
  String get languageSelectorTitle => 'espagnol';

  @override
  String get french => 'Français';

  @override
  String get spanish => 'Español';

  @override
  String get catalan => 'Català';

  @override
  String get english => 'English';

  @override
  String get phoneLanguage => 'Idioma del teléfono';

  @override
  String get cardIsValid => 'La tarjeta es válida';

  @override
  String get cardIsExpired => 'La tarjeta ha caducado';

  @override
  String get signatureIsInvalid => 'La firma no es válida';

  @override
  String get statusIsInvalid => 'El estado no es válido';

  @override
  String get statuslListSignatureFailed =>
      'Error en la firma de la lista de estado';

  @override
  String get statusList => 'Lista de estados';

  @override
  String get statusListIndex => 'Índice de lista de estados';

  @override
  String get theWalletIsSuspended => 'La cartera digital está suspendida.';

  @override
  String get jwkThumbprintP256Key => 'Huella digital JWK P-256';

  @override
  String get walletBlockedPopupTitle => 'Bloqueado 10 minutos';

  @override
  String get walletBlockedPopupDescription =>
      'Demasiados intentos fallidos, tu cartera digital está bloqueada por seguridad.\nReinicia tu cartera para usar los servicios nuevamente.';

  @override
  String get deleteMyWalletForWrontPincodeTitle =>
      'Cuenta bloqueada después de 3 intentos fallidos';

  @override
  String get deleteMyWalletForWrontPincodeDescription =>
      'Por tu seguridad debes reiniciar tu cartera digital para usar nuestros servicios nuevamente.';

  @override
  String get walletBloced => 'Cuenta bloqueada';

  @override
  String get deleteMyWallet => 'Eliminar mi cuenta';

  @override
  String get pincodeRules =>
      'Tu código secreto no puede ser una secuencia ni tener 4 dígitos idénticos.';

  @override
  String get pincodeSerie => 'No puedes tener 4 dígitos idénticos.';

  @override
  String get pincodeSequence => 'No puedes tener una secuencia de 4 dígitos.';

  @override
  String get pincodeDifferent =>
      'Código incorrecto.\nLos códigos no son iguales.';

  @override
  String codeSecretIncorrectDescription(Object count, Object plural) {
    return 'Ten cuidado, te quedan $count intento$plural.';
  }

  @override
  String get languageSettings => 'Configuración de idioma';

  @override
  String get languageSettingsDescription => 'Elige tu idioma';

  @override
  String get themeSettings => 'Configuración de tema';

  @override
  String get themeSettingsDescription => 'Elige tu tema';

  @override
  String couldNotFindTheAccountWithThisAddress(Object address) {
    return 'No se pudo encontrar la dirección $address en tu lista de cuentas.';
  }

  @override
  String deleteAccountMessage(Object account) {
    return '¿Estás seguro de que quieres eliminar $account?';
  }

  @override
  String get cannotDeleteCurrentAccount =>
      'Lo siento, no puedes eliminar la cuenta actual';

  @override
  String get invalidClientErrorDescription =>
      'client_id no cumple con client_id_scheme';

  @override
  String get vpFormatsNotSupportedErrorDescription =>
      'La cartera digital no admite ninguno de los formatos solicitados por el Verificador, como los incluidos en el parámetro de registro vp_formats.';

  @override
  String get invalidPresentationDefinitionUriErrorDescription =>
      'No se puede acceder a la URL de \'Definición de Presentación\'.';

  @override
  String get toStopDisplayingThisPopupDeactivateTheDeveloperModeInTheSettings =>
      'Para dejar de mostrar esta ventana, desactiva el \'modo desarrollador\' en la configuración.';

  @override
  String get warningDialogSubtitle =>
      'La página de recuperación contiene información sensible. Por favor, asegúrate de mantenerla privada.';

  @override
  String get accountPrivateKeyAlert =>
      'La página de recuperación contiene información sensible. Por favor, asegúrate de mantenerla privada.';

  @override
  String get etherlinkNetwork => 'Red Etherlink';

  @override
  String get etherlinkAccount => 'Cuenta Etherlink';

  @override
  String get etherlinkAccountDescription =>
      'Crear una nueva dirección blockchain Etherlink';

  @override
  String get etherlinkAccountCreationCongratulations =>
      'Tu nueva cuenta Etherlink ha sido creada exitosamente.';

  @override
  String get etherlinkProofMessage => '';

  @override
  String get notification => 'Notificación';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get notificationTitle =>
      '¡Bienvenido a las Notificaciones!\nMantente informado de actualizaciones importantes.';

  @override
  String get chatRoom => 'Sala de chat';

  @override
  String get notificationRoom => 'Sala de notificaciones';

  @override
  String get notificationSubtitle => 'Habilitar para recibir notificaciones';

  @override
  String get header => 'Encabezado';

  @override
  String get payload => 'Payload';

  @override
  String get data => 'Datos';

  @override
  String get keyBindingHeader => 'Key Binding Header';

  @override
  String get keyBindingPayload => 'Key Binding Payload';

  @override
  String get ebsiV4DecentralizedId => 'did:key EBSI V4 P-256';

  @override
  String get noNotificationsYet => 'Aún no hay notificaciones';

  @override
  String get activityLog => 'Registro de Actividad';

  @override
  String get activityLogDescription => 'Ver tus actividades';

  @override
  String get walletInitialized => 'Cartera digital inicializada';

  @override
  String get backupCredentials => 'Credenciales de respaldo';

  @override
  String get restoredCredentials => 'Credenciales restauradas';

  @override
  String deletedCredential(Object credential) {
    return 'Credencial $credential eliminada';
  }

  @override
  String presentedCredential(Object credential, Object domain) {
    return 'Credencial $credential presentada a $domain';
  }

  @override
  String get keysImported => 'Claves importadas';

  @override
  String get approveProfileTitle => 'Instalar configuración';

  @override
  String approveProfileDescription(Object company) {
    return '¿Autorizas instalar la configuración de $company?';
  }

  @override
  String get updateProfileTitle => 'Actualizar configuración';

  @override
  String updateProfileDescription(Object company) {
    return '¿Autorizas actualizar la configuración de $company?';
  }

  @override
  String get replaceProfileTitle => 'Instalar una nueva configuración';

  @override
  String replaceProfileDescription(Object company) {
    return '¿Autorizas reemplazar la configuración actual con la de $company?';
  }

  @override
  String get saveBackupCredentialSubtitle2 =>
      'Para recuperar tus credenciales necesitarás este archivo de respaldo.';

  @override
  String get createWallet => 'Crear cartera digital';

  @override
  String get restoreWallet => 'Restaurar cartera digital';

  @override
  String get showWalletRecoveryPhraseSubtitle2 =>
      'Esta frase de recuperación será requerida para restaurar una cartera digital en la instalación.';

  @override
  String get documentation => 'Documentación';

  @override
  String get restoreACryptoWallet => 'Restaurar una cripto billetera';

  @override
  String restoreAnAppBackup(Object appName) {
    return 'Restaurar un respaldo de $appName';
  }

  @override
  String get credentialPickShare => 'Compartir';

  @override
  String get credentialPickTitle =>
      'Elige la(s) credencial(es) que quieres obtener';

  @override
  String get credentialShareTitle =>
      'Elige la(s) credencial(es) para compartir';

  @override
  String get enterYourSecretCode => 'Introduce tu código secreto.';

  @override
  String get jwk => 'JWK';

  @override
  String get typeYourPINCodeToOpenTheWallet =>
      'Introduce tu código PIN para abrir la billetera';

  @override
  String get typeYourPINCodeToShareTheData =>
      'Introduce tu código PIN para compartir los datos';

  @override
  String get typeYourPINCodeToAuthenticate =>
      'Introduce tu código PIN para autenticarte';

  @override
  String get credentialIssuanceIsStillPending =>
      'La emisión de la credencial está pendiente';

  @override
  String get bakerFee => 'Comisión de Baker';

  @override
  String get storageFee => 'Comisión de almacenamiento';

  @override
  String get doYouWantToSetupTheProfile => '¿Quieres configurar el perfil?';

  @override
  String get thisFeatureIsNotSupportedYetForEtherlink =>
      'Esta función aún no es compatible con Etherlink Chain.';

  @override
  String get walletSecurityAndBackup => 'Seguridad y respaldo de la billetera';

  @override
  String addedCredential(Object credential, Object domain) {
    return 'Credencial $credential añadida por $domain';
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
  String get deleteDigit => 'Eliminar';

  @override
  String get aiPleaseWait => 'This treatment can take up to 1min';

  @override
  String get trustedList => 'Use trusted list';

  @override
  String get trustedListSubtitle =>
      'List of trusted entities in the current ecosystem. You are warned in case of interaction with non trusted entity.';

  @override
  String get notTrustedEntity =>
      'This entity is not in the trusted list. You should be very cautious with untrusted entities.';
}
