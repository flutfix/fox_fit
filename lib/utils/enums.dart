import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/config.dart';

class Enums {
  /// Для получения иконки стадии воронки по [IconUid]
  static String getIconStage({required StagePipelineType stageType}) {
    switch (stageType) {
      case StagePipelineType.assigned:
        return Images.checkMark;

      case StagePipelineType.transferringRecord:
        return Images.refresh;

      case StagePipelineType.nonCall:
        return Images.phoneMinus;

      case StagePipelineType.rejection:
        return Images.cross;

      case StagePipelineType.coordinator:
        return Images.coordinatorSvg;

      case StagePipelineType.appointment:
        return Images.assigned;

      case StagePipelineType.sale:
        return Images.saleConfirmation;

      default:
        return Images.assigned;
    }
  }

  /// Для отображения комментария
  static bool getIsDisplayComment({required StagePipelineType stageType}) {
    switch (stageType) {
      case StagePipelineType.assigned:
        return false;

      case StagePipelineType.transferringRecord:
        return false;

      case StagePipelineType.nonCall:
        return true;

      case StagePipelineType.rejection:
        return true;

      case StagePipelineType.coordinator:
        return false;

      case StagePipelineType.appointment:
        return false;

      default:
        return false;
    }
  }

  static ClientType getClientType({required String clientUid}) {
    if (clientUid == Client.fresh) {
      return ClientType.fresh;
    } else if (clientUid == Client.assigned) {
      return ClientType.assigned;
    } else if (clientUid == Client.conducted) {
      return ClientType.conducted;
    } else if (clientUid == Client.permanent) {
      return ClientType.permanent;
    }
    return ClientType.fresh;
  }

  static StagePipelineType getStagePipelineType({required String stageUid}) {
    if (stageUid == StagePipeline.assigned) {
      return StagePipelineType.assigned;
    } else if (stageUid == StagePipeline.transferringRecord) {
      return StagePipelineType.transferringRecord;
    } else if (stageUid == StagePipeline.nonCall) {
      return StagePipelineType.nonCall;
    } else if (stageUid == StagePipeline.rejection) {
      return StagePipelineType.rejection;
    } else if (stageUid == StagePipeline.coordinator) {
      return StagePipelineType.coordinator;
    }
    return StagePipelineType.assigned;
  }

  static String getStagePipelineUid(
      {required StagePipelineType stagePipelineType}) {
    switch (stagePipelineType) {
      case StagePipelineType.assigned:
        return StagePipeline.assigned;

      case StagePipelineType.transferringRecord:
        return StagePipeline.transferringRecord;

      case StagePipelineType.nonCall:
        return StagePipeline.nonCall;

      case StagePipelineType.rejection:
        return StagePipeline.rejection;

      case StagePipelineType.coordinator:
        return StagePipeline.coordinator;

      default:
        return StagePipeline.assigned;
    }
  }

  static String getAppointmentTypeString(
      {required AppointmentType appointmentType}) {
    switch (appointmentType) {
      case AppointmentType.personal:
        return 'Personal';

      case AppointmentType.group:
        return 'Group';

      default:
        return 'Personal';
    }
  }

  static AppointmentType getAppointmentType(
      {required String appointmentTypeString}) {
    switch (appointmentTypeString) {
      case 'Personal':
        return AppointmentType.personal;

      case 'Group':
        return AppointmentType.group;

      default:
        return AppointmentType.personal;
    }
  }

  static PaymentStatusType getPaymentStatusType(
      {required String paymentStatusString}) {
    switch (paymentStatusString) {
      case 'DoneAndPayed':
        return PaymentStatusType.doneAndPayed;

      case 'PlannedAndPayed':
        return PaymentStatusType.plannedAndPayed;

      case 'ReservedNeedPayment':
        return PaymentStatusType.reservedNeedPayment;

      default:
        return PaymentStatusType.reservedNeedPayment;
    }
  }
}

enum StagePipelineType {
  assigned,
  transferringRecord,
  nonCall,
  rejection,
  coordinator,
  appointment,
  sale,
}

enum ClientType {
  fresh,
  assigned,
  conducted,
  permanent,
  sleeping,
  coordinator,
}
enum CustomerContainerType {
  birthDate,
  balance,
}
enum UserRole {
  trainer,
  coordinator,
}

enum CustomersPageType {
  general,
  coordinator,
  sleep,
}

enum CustomersContainerType {
  justName,
  age,
  services,
}

enum AppointmentType {
  personal,
  group,
}

enum PaymentStatusType {
  /// Проведено и оплачено
  doneAndPayed,

  /// Запланировано и оплачено
  plannedAndPayed,

  /// Запланирвоно и нужна оплата
  reservedNeedPayment,
}

enum AppointmentRecordType {
  create,
  edit,
  group,
  revoke,
  view,
  groupView,
}
