import 'package:fox_fit/config/assets.dart';
import 'package:fox_fit/config/config.dart';

class Enums {
  /// Для получения иконки стадии воронки по [IconUid]
  static String getIconStage({required StagePipelineType stageType}) {
    switch (stageType) {
      case StagePipelineType.assigned:
        return Images.assigned;

      case StagePipelineType.transferringRecord:
        return Images.refresh;

      case StagePipelineType.nonCall:
        return Images.phoneMinus;

      case StagePipelineType.rejection:
        return Images.cross;

      case StagePipelineType.coordinator:
        return Images.coordinatorSvg;

      case StagePipelineType.training:
        return Images.assigned;

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

      case StagePipelineType.training:
        return false;

      default:
        return false;
    }
  }

  static getClientType({required String clientUid}) {
    switch (clientUid) {
      case Client.fresh:
        return ClientType.fresh;

      case Client.assigned:
        return ClientType.assigned;

      case Client.conducted:
        return ClientType.conducted;

      case Client.permanent:
        return ClientType.permanent;

      // case Client.sleeping:
      //   return ClientType.sleeping;

      case Client.coordinator:
        return ClientType.coordinator;

      default:
        return ClientType.fresh;
    }
  }

  static getStagePipelineType({required String stageUid}) {
    switch (stageUid) {
      case StagePipeline.assigned:
        return StagePipelineType.assigned;

      case StagePipeline.transferringRecord:
        return StagePipelineType.transferringRecord;

      case StagePipeline.nonCall:
        return StagePipelineType.nonCall;

      case StagePipeline.rejection:
        return StagePipelineType.rejection;

      case StagePipeline.coordinator:
        return StagePipelineType.coordinator;

      default:
        return StagePipelineType.assigned;
    }
  }

  static getStagePipelineUid({required StagePipelineType stagePipelineType}) {
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

  static getTrainingTypeString({required TrainingType trainingType}) {
    switch (trainingType) {
      case TrainingType.personal:
        return 'Personal';

      case TrainingType.group:
        return 'Group';

      default:
        return 'Personal';
    }
  }

  static getTrainingType({required String trainingType}) {
    switch (trainingType) {
      case 'Personal':
        return TrainingType.personal;

      case 'Group':
        return TrainingType.group;

      default:
        return TrainingType.personal;
    }
  }

  static getPaymentStatusType({required String paymentStatusString}) {
    switch (paymentStatusString) {
      case 'DoneAndPayed':
        return PaymentStatusType.doneAndPayed;

      case 'PlannedAndPayed':
        return PaymentStatusType.plannedAndPayed;

      case 'ReservedNeedPayment':
        return PaymentStatusType.reservedNeedPayment;

      default:
        return StagePipeline.assigned;
    }
  }
}

enum StagePipelineType {
  assigned,
  transferringRecord,
  nonCall,
  rejection,
  coordinator,
  training,
}

enum ClientType {
  fresh,
  assigned,
  conducted,
  permanent,
  sleeping,
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

enum TrainingType {
  personal,
  group,
}

enum PaymentStatusType {
  /// Проведено и оплачено
  doneAndPayed,

  /// Запланировано и оплачено
  plannedAndPayed,

  /// Запланирвоноо и нужна оплата
  reservedNeedPayment,
}
