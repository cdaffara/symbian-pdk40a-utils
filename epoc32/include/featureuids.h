// featureUIDs.h
//
// Copyright (c) 2009 Nokia Corporation and/or its subsidiary(-ies).  All rights reserved.
//
// Feature UID allocations for all Symbian OS platforms
//
// This file is managed by the System Design Authority (sda@symbian.com)
// To allocate a new feature UID, please email the SDA
// 
// The following UID ranges are allocated for features 
// that default to reporting "feature present"
//		0x10279806 - 0x10281805
//
// All other UIDs default to reporting "feature not present"
//

/**
@publishedAll
@released
*/
namespace NFeature {
	// default present
	const TUid KConnectivity = {0x10279816};
	const TUid KFax = {0x10279806};
	const TUid KIPQoS = {0x10279812};
	const TUid KLocationManagement = {0x10279818};
	const TUid KNetworkQoS = {0x10279813};
	const TUid KObex = {0x1027980C};
	const TUid KRtpRtcp = {0x1027980D};
	const TUid KSip = {0x1027980F};

	// default not present
	const TUid K3DMenu = {0x5E7};
	const TUid K3GpExtension = {0x638};
	const TUid KAac = {0x4B};
	const TUid KAacEncoderPlugin = {0x475};
	const TUid KAacPlusDecoderPlugin = {0x477};
	const TUid KAccessoryFw = {0x47E};
	const TUid KAllowUpgradeHelix = {0x6A3};
	const TUid KAlwaysOnLine = {0x436};
	const TUid KAlwaysOnLineEmail = {0x44D};
	const TUid KAmbientLightSensor = {0x5F9};
	const TUid KAmrNb = {0x49};
	const TUid KAmrWb = {0x4A};
	const TUid KArmAvc = {0x65E};
	const TUid KArmMdfH263mpeg4Dec = {0x66C};
	const TUid KArmMdfH264Dec = {0x66A};
	const TUid KArmMdfPostprocessor = {0x66D};
	const TUid KArmMdfRealvideoDec = {0x66B};
	const TUid KAsynchFileSaveQueue = {0x6A7};
	const TUid KAtHandler = {0xDF};
	const TUid KAudioAac = {0x426};
	const TUid KAudioControllerStreaming = {0x637};
	const TUid KAudioEffectsApi = {0x1F1};
	const TUid KAudioMessaging = {0x61D};
	const TUid KAudioPlaylist = {0x427};
	const TUid KAudioResourceIndications = {0x1F3};
	const TUid KAutoRedialForVideoCall = {0x6BB};
	const TUid KAvcDecoder = {0x61F};
	const TUid KAvcEncoder = {0x620};
	const TUid KAvkonELaf = {0x3F2};
	const TUid KBasicLocationInfoDisplay = {0x5E9};
	const TUid KBeatnikAudioengine = {0x668};
	const TUid KBluetooth = {0xC};
	const TUid KBluetoothGPSPositioningPlugin = {0x7A};
	const TUid KBrandingServer = {0x679};
	const TUid KBrowserAdaptiveBookm = {0xA3};
	const TUid KBrowserAudioPlugin = {0x462};
	const TUid KBrowserFileUpload = {0x44B};
	const TUid KBrowserFrames = {0x42D};
	const TUid KBrowserFullScr = {0x42A};
	const TUid KBrowserNarrowScreen = {0x424};
	const TUid KBrowserNetscapeAPI = {0x44F};
	const TUid KBrowserProgressInd = {0x428};
	const TUid KBrowserProgressiveDownload = {0x6BC};
	const TUid KBrowserUrlCompletion = {0xA5};
	const TUid KBrowserVideoPlugin = {0x646};
	const TUid KBtAudio = {0xF};
	const TUid KBticEnabled = {0x640};
	const TUid KBtImagingProfile = {0x13};
	const TUid KBtPbap = {0x696};
	const TUid KBtSap = {0xDE};
	const TUid KBtStereoAudio = {0x62C};
	const TUid KBtTestMode = {0xE0};
	const TUid KCaeVrCustomCommands = {0x83};
	const TUid KCallImagetext = {0x5DF};
	const TUid KCamera = {0x2};
	const TUid KCameraBurstMode = {0x84};
	const TUid KCameraFullscreenViewfinder = {0x647};
	const TUid KCellBroadcast = {0x442};
	const TUid KChatNG = {0x672};
	const TUid KCommonDsy = {0x129};
	const TUid KCommonTsy = {0x125};
	const TUid KCommonVoip = {0x12A};
	const TUid KConnMonExtension = {0x6C};
	const TUid KConnMonUI = {0x451};
	const TUid KContentDownload = {0x5E0};
	const TUid KCsVideoTelephony = {0x59};
	const TUid KDefaultPositioningPlugin = {0x10285D6B};
	const TUid KDhcp = {0x6B};
	const TUid KDialupNetworking = {0x67C};
	const TUid KDisplayPost = {0x64A};
	const TUid KDpb = {0x20};
	const TUid KDriveModeCanRestrictMtCalls = {0x584};
	const TUid KDRM = {0x5B};
	const TUid KDrmClock = {0x60};
	const TUid KDrmFull = {0x5D};
	const TUid KDrmOma2 = {0x62};
	const TUid KDrmPhase2 = {0x5F};
	const TUid KDynamicProfiles = {0x420};
	const TUid KEdgeKnowledge = {0x68};
	const TUid KEditKey = {0x688};
	const TUid KEmailMceIntegration = {0x7E};
	const TUid KEmailUi = {0x582};
	const TUid KEmergencyCallsEnabledInOfflineMode = {0x126};
	const TUid KEnableIsiCommunicationInUsbChargingMode = {0x135};
	const TUid KEnPolicyDos = {0x45E};
	const TUid KEqualizer = {0x5DE};
	const TUid KExtendedStartup = {0x421};
	const TUid KFfAdditionalFonts = {0xF1};
	const TUid KFfAvkonEmotionIconEnabled = {0xD3};
	const TUid KFfCapacitiveDisplay = {0xB7};
	const TUid KFfConnectionOverride = {0xB3};
	const TUid KFfContactsCompanyNames = {0xEC};
	const TUid KFfContactsMerge = {0x10C};
	const TUid KffContactsMycard = {0x10B};
	const TUid KFfContactsRemoteLookup = {0xEA};
	const TUid KFfContactsSocial = {0x111};
	const TUid KFfDeviceEncryptionFeature = {0xFA};
	const TUid KFfEmailFramework = {0x87};
	const TUid KFfEmailProtocolPlugins = {0xD7};
	const TUid KFfIaupdatePhase2 = {0xB9};
	const TUid KFfNcdEngine = {0x3D};
	const TUid KFfNcdUi = {0x3E};
	const TUid KFfOmaScomoAdapter = {0xC5};
	const TUid KFfRuntimeDeviceCapabilityConfiguration = {0xC6};
	const TUid KFfSimlessOfflineSupport = {0x82};
	const TUid KFfTacticons = {0xB8};
	const TUid KFfTarmCapabilityBasedAccess = {0xD6};
	const TUid KFfVoiceCallContinuity = {0x98};
	const TUid KFfWsNcim = {0x99};
	const TUid KFlashLiteBrowserPlugin = {0x47A};
	const TUid KFlashLiteViewer = {0x479};
	const TUid KFmRadio = {0x5};
	const TUid KFmTx = {0x6A9};
	const TUid KGeneralSearchFramework = {0x670};
	const TUid KGeneralSearchUi = {0x671};
	const TUid KHandwritingRecognitionInput = {0x644};
	const TUid KHelp = {0x3F4};
	const TUid KHlpClearKey = {0x2AF8};
	const TUid KHlpMsk = {0x2AFB};
	const TUid KHsxpaSupport = {0x682};
	const TUid KHttpDigestAuth = {0x43C};
	const TUid KHwrmTargetModifierPlugin = {0x681};
	const TUid KIAUpdate = {0x1E};
	const TUid KICalSupport = {0x634};
	const TUid KId3V2Metadata = {0x1EF};
	const TUid KIm = {0x21};
	const TUid KImageViewer = {0x692};
	const TUid KImpsStandaloneIpCir = {0x22};
	const TUid KIncludeAacCMMFCodec = {0x1EC};
	const TUid KIncludeAmrNbCMMFCodec = {0x121};
	const TUid KIncludeAmrWbCMMFCodec = {0x1EB};
	const TUid KIncludeEaacplusCmmfcodec = {0x5F1};
	const TUid KIncludeMp3CMMFCodec = {0x1ED};
	const TUid KIncludeQcelpCMMFCodec = {0x1EE};
	const TUid KIncludeUsbRndis = {0xC8};
	const TUid KIndicRomContent = {0x69E};
	const TUid KInfrared = {0xB};
	const TUid KInstallerSisx = {0x583};
	const TUid KIPSec = {0x66};
	const TUid KIPv6 = {0x440};
	const TUid KJ2MEWebServicesAPI = {0x96};
	const TUid KJapaneseLargerDictionary = {0x5ED};
	const TUid KJava = {0x697};
	const TUid KJava3DAPI = {0x92};
	const TUid KJavaApiEnhancementsIap = {0x683};
	const TUid KJavaApiEnhancementsMobinfo = {0x684};
	const TUid KJavaESWT = {0x680};
	const TUid KJavaFileAPI = {0x90};
	const TUid KJavaJsr177SecurityAndTrustServices = {0x58B};
	const TUid KJavaJsr177SecurityAndTrustServicesApdu = {0x631};
	const TUid KJavaJsr177SecurityAndTrustServicesCrypto = {0x633};
	const TUid KJavaJsr177SecurityAndTrustServicesPki = {0x632};
	const TUid KJavaJsr205Wma20Support = {0x587};
	const TUid KJavaJsr2262DSvgAPI = {0x58A};
	const TUid KJavaJsr2343DAudioAndMusicCapabilities = {0x588};
	const TUid KJavaLocationAPI = {0x93};
	const TUid KJavaMIDP20 = {0x585};
	const TUid KJavaMMAPI11 = {0x8F};
	const TUid KJavaPIMAPI = {0x91};
	const TUid KJsr135Support = {0x46A};
	const TUid KKeypadNoSlider = {0x3F5};
	const TUid KLandmarks = {0x70};
	const TUid KLandmarksConverter = {0x7B};
	const TUid KLayout240_320 = {0x465};
	const TUid KLayout240_320_LargeScreen = {0x655};
	const TUid KLayout320_240 = {0x466};
	const TUid KLayout320_240_LargeScreen = {0x656};
	const TUid KLayout320_480_Touch = {0x65B};
	const TUid KLayout360_640_Touch = {0x6A5};
	const TUid KLayout480_320_Touch = {0x65C};
	const TUid KLayout640_360_Touch = {0x6A4};
	const TUid KLibxml2 = {0x10286747};
	const TUid KLibxml2DOMXPathAPI = {0x10286727};
	const TUid KLibxml2SAXParser = {0x10286707};
	const TUid KLocation = {0x72};
	const TUid KLocationAdvancedDialog = {0x102859F3};
	const TUid KLocationAPIVariant2 = {0x10285D69};
	const TUid KLocationCentre = {0x6A6};
	const TUid KLocationPrivacyRequestAPIs = {0x102859F2};
	const TUid KLocationSysUi = {0x7C};
	const TUid KLoggerGprs = {0x67};
	const TUid KLunarCalendar = {0x3F9};
	const TUid KMacromediaFlash6 = {0x4F};
	const TUid KMapAndNavigationAiwProvider = {0x642};
	const TUid KMediator = {0x64E};
	const TUid KMediaTransferProtocol = {0x6A1};
	const TUid KMeetingRequestEnabler = {0x636};
	const TUid KMidi = {0x3F3};
	const TUid KMmc = {0x1};
	const TUid KMmcEject = {0x693};
	const TUid KMmcHotswap = {0x434};
	const TUid KMmcLock = {0x687};
	const TUid KMmCommsAvController = {0x1F9};
	const TUid KMmCommsEngine = {0x1F5};
	const TUid KMmfDrmUtility = {0x1F0};
	const TUid KMMS = {0xF4};
	const TUid KMobileActiveSync = {0x673};
	const TUid KMobileIP = {0x10281819};
	const TUid KMp3 = {0x47};
	const TUid KMpeg4VideoEncoding = {0x50};
	const TUid KMpegAacEncoding = {0x11A};
	const TUid KMrtSdkLibraries = {0x67F};
	const TUid KMTP = {0x1F8};
	const TUid KMultimediaSharing = {0x678};
	const TUid KMultipleProvCtx = {0x423};
	const TUid KNetworkRegistration = {0x69};
	const TUid KNpProxy = {0x63E};
	const TUid KOCSP = {0x95};
	const TUid KOfflineMode = {0x7};
	const TUid KOmaEmailNotifications = {0x661};
	const TUid KOmaImps12 = {0x694};
	const TUid KOmaProv = {0xE4};
	const TUid KOmaSuplPlugins = {0x630};
	const TUid KOnScreenDialer = {0x6A0};
	const TUid KOpenGLES3DApi = {0xA};
	const TUid KOpenGLESSWImplementation = {0xD2};
	const TUid KOpenvgSwImplementation = {0x645};
	const TUid KOperatorCache = {0x42F};
	const TUid KOperatorMenu = {0x422};
	const TUid KPenSupport = {0x19A};
	const TUid KPenSupportCalibration = {0x67A};
	const TUid KPhoneCnap = {0x407};
	const TUid KPhoneTty = {0x408};
	const TUid KPlugAndPlayMobileServices = {0x67B};
	const TUid KPowerSave = {0x6AD};
	const TUid KPresence = {0x24};
	const TUid KPresenceFramework = {0x665};
	const TUid KPrint = {0x5FF};
	const TUid KPrivacyFramework = {0x73};
	const TUid KProductIncludesHomeScreenEasyDialing = {0x13DD};
	const TUid KProtocolGsm = {0x51};
	const TUid KProtocolWcdma = {0x52};
	const TUid KProtocolWlan = {0x6D};
	const TUid KPushSL = {0x41E};
	const TUid KPushWhiteList = {0xE3};
	const TUid KQos = {0x65};
	const TUid KQwertyInput = {0x199};
	const TUid KRealPlayer = {0x410};
	const TUid KRealPlayerAsDefault = {0x669};
	const TUid KRemoteLock = {0x674};
	const TUid KRemoteStorageFw = {0x62D};
	const TUid KRockerKey = {0x78};
	const TUid KRssFeeds = {0xA7};
	const TUid KRtpStack = {0x635};
	const TUid KRV9 = {0x446};
	const TUid KS60FmRadioApplication = {0x603};
	const TUid KS60MtpController = {0x110};
	const TUid KSapApplicationManagement = {0x628};
	const TUid KSapDeviceLockEnhancements = {0x64B};
	const TUid KSapEmbeddedLinkAdapter = {0x621};
	const TUid KSapIdleSoftkeyAdapter = {0x622};
	const TUid KSapOperatorLogoAdapter = {0x623};
	const TUid KSapPolicyManagement = {0x62A};
	const TUid KSapScreensaverAdapter = {0x624};
	const TUid KSapStartupAdapter = {0x625};
	const TUid KSapTerminalControlFw = {0x629};
	const TUid KSapThemesAdapter = {0x626};
	const TUid KSapUiSettingServer = {0x62B};
	const TUid KSapWallpaperAdapter = {0x627};
	const TUid KSatBip = {0x606};
	const TUid KSatCallControl = {0x605};
	const TUid KSatDisplayText = {0x607};
	const TUid KSatGetInkey = {0x608};
	const TUid KSatGetInput = {0x609};
	const TUid KSatLanguageNotification = {0x60A};
	const TUid KSatLaunchBrowser = {0x60B};
	const TUid KSatMoSmControl = {0x60C};
	const TUid KSatPlayTone = {0x60D};
	const TUid KSatProvideLocalInfo = {0x60E};
	const TUid KSatRefresh = {0x60F};
	const TUid KSatSelectItem = {0x610};
	const TUid KSatSendDtfm = {0x611};
	const TUid KSatSendSm = {0x612};
	const TUid KSatSendSs = {0x613};
	const TUid KSatSendUssd = {0x614};
	const TUid KSatSetupCall = {0x615};
	const TUid KSatSetUpEventList = {0x616};
	const TUid KSatSetUpIdleModeText = {0x617};
	const TUid KSatSetUpMenu = {0x618};
	const TUid KScalableIcons = {0x469};
	const TUid KSeamlessLinks = {0x432};
	const TUid KSelectableEmail = {0x7D};
	const TUid KSendFileInCall = {0x43F};
	const TUid KSeries60NativeBrowser = {0xA8};
	const TUid KSettingsProtection = {0x41A};
	const TUid KShowPanics = {0x433};
	const TUid KSideVolumeKeys = {0xCF};
	const TUid KSimCard = {0x58};
	const TUid KSimCertificates = {0x19};
	const TUid KSimPhonebookMatch = {0x124};
	const TUid KSimulationPositioningPlugin = {0x10285D6C};
	const TUid KSind = {0x48};
	const TUid KSipSimplePresenceProtocol = {0x663};
	const TUid KSlideshowScreensaver = {0x68C};
	const TUid KSmartCardProv = {0x1B};
	const TUid KSmartmsgSMSBookmarkReceiving = {0x452};
	const TUid KSmartmsgSMSGmsMessageReceiving = {0x458};
	const TUid KSmartmsgSMSOperatorLogoReceiving = {0x456};
	const TUid KSmartmsgSMSRingingToneReceiving = {0x457};
	const TUid KSmartmsgSMSVcalReceiving = {0x45A};
	const TUid KSmartmsgSMSVcalSending = {0x45C};
	const TUid KSmartmsgSMSVcardReceiving = {0x45B};
	const TUid KSmartmsgSMSVcardSending = {0x45D};
	const TUid KSmilEditor = {0x431};
	const TUid KSrcs = {0x11};
	const TUid KSuplFramework = {0x62F};
	const TUid KSupportedFeature1 = {0x3E8};
	const TUid KSupportedFeature2 = {0x3EA};
	const TUid KSvgt = {0x4D};
	const TUid KSvgtScreensaverPlugin = {0x66F};
	const TUid KSvgtViewer = {0x473};
	const TUid KSymbianMultimediaA3fdevsoundId = {0x4C};
	const TUid KSyncMlDm = {0x29};
	const TUid KSyncMlDmDs = {0x2F};
	const TUid KSyncMlDmEmail = {0x31};
	const TUid KSyncMlDmFota = {0x3A};
	const TUid KSyncMlDmIAP = {0x30};
	const TUid KSyncMlDmImps = {0x39};
	const TUid KSyncMlDmMMS = {0x32};
	const TUid KSyncMlDmObex = {0x36};
	const TUid KSyncMlDmOta = {0x68F};
	const TUid KSyncMlDmSIP = {0x3C};
	const TUid KSyncMlDmVoIP = {0x3B};
	const TUid KSyncMlDmWlan = {0x37};
	const TUid KSyncMlDs = {0x2A};
	const TUid KSyncMlDsAiwProvider = {0x5EC};
	const TUid KSyncMlDsAlert = {0x34};
	const TUid KSyncMlDsBookmark = {0x6AA};
	const TUid KSyncMlDsCal = {0x2E};
	const TUid KSyncMlDsCon = {0x2D};
	const TUid KSyncMlDsEmail = {0x2C};
	const TUid KSyncMlDsMMS = {0x2B};
	const TUid KSyncMlDsNotepad = {0x35};
	const TUid KSyncMlDsOverHttp = {0x586};
	const TUid KSyncMlDsSms = {0x63F};
	const TUid KSyncMlIsync = {0x690};
	const TUid KSyncMlObex = {0x33};
	const TUid KTactileFeedback = {0x6B6};
	const TUid KThaiCalendar = {0x66E};
	const TUid KTouchCallHandling = {0x6B3};
	const TUid KTvOut = {0x604};
	const TUid KUiTransitionEffects = {0x666};
	const TUid KUiZoom = {0x65F};
	const TUid KUpin = {0x64C};
	const TUid KUpnpAvcp = {0x5FD};
	const TUid KUpnpMediaserver = {0x67D};
	const TUid KUpnpStack = {0x5F8};
	const TUid KUsb = {0xD};
	const TUid KUsbCharging = {0x77};
	const TUid KUsbDeviceLock = {0x474};
	const TUid KUsbMultiPersonality = {0x5FE};
	const TUid KUsbPictbridge = {0x5FB};
	const TUid KUsbRemotePersonality = {0x69A};
	const TUid KUseAacCMMFCodec = {0x11E};
	const TUid KUseAmrNbCMMFCodec = {0x11C};
	const TUid KUseAmrWbCMMFCodec = {0x11D};
	const TUid KUseDrmEngineInCcp = {0x5C};
	const TUid KUseEaacplusCmmfCodec = {0x5F2};
	const TUid KUseMp3CMMFCodec = {0x11F};
	const TUid KUseQcelpCMMFCodec = {0x120};
	const TUid KUSSD = {0x443};
	const TUid KVfpHwSupport = {0x685};
	const TUid KVibra = {0x19B};
	const TUid KVideoMenu = {0x662};
	const TUid KVideoRecorder = {0xD0};
	const TUid KVirtualFullscrQwertyInput = {0x40};
	const TUid KVirtualItutInput = {0x41};
	const TUid KVirtualKeyboardInput = {0x643};
	const TUid KWebWidgets = {0x69B};
	const TUid KWim = {0x18};
	const TUid KWindowsMedia = {0x675};
	const TUid KWindowsMediaDrm = {0x676};
	const TUid KWma = {0x1F7};
	const TUid KWorldClock = {0x44A};
	const TUid KXdm = {0x5F3};
	const TUid KXdmLocalStorage = {0x5F5};
	const TUid KXdmXcap = {0x5F4};
	const TUid KXspExtensionManager = {0x69C};
}
