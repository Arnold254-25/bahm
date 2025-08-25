import 'package:bahm/features/split_bill/domain/models/split_bill_model.dart';
import 'package:bahm/features/split_bill/domain/models/participant_model.dart';

class SplitBillService {
  /// Calculate equal split among participants
  List<ParticipantModel> calculateEqualSplit(
    double totalAmount,
    List<ParticipantModel> participants,
  ) {
    final numberOfParticipants = participants.length;
    if (numberOfParticipants == 0) return participants;

    final amountPerPerson = totalAmount / numberOfParticipants;
    
    return participants.map((participant) {
      return participant.copyWith(amountOwed: amountPerPerson);
    }).toList();
  }

  /// Calculate percentage-based split
  List<ParticipantModel> calculatePercentageSplit(
    double totalAmount,
    List<ParticipantModel> participants,
    Map<String, double> percentages,
  ) {
    return participants.map((participant) {
      final percentage = percentages[participant.id] ?? 0.0;
      final amount = totalAmount * (percentage / 100);
      return participant.copyWith(amountOwed: amount);
    }).toList();
  }

  /// Validate custom amounts to ensure they sum to total
  bool validateCustomAmounts(
    double totalAmount,
    List<ParticipantModel> participants,
  ) {
    final totalCustomAmount = participants.fold(
      0.0,
      (sum, participant) => sum + participant.amountOwed,
    );
    
    return (totalCustomAmount - totalAmount).abs() < 0.01;
  }

  /// Create a new split bill with calculated amounts
  SplitBillModel createSplitBill({
    required String title,
    required double totalAmount,
    required SplitType splitType,
    required String creatorId,
    required List<ParticipantModel> participants,
    Map<String, double>? percentages,
  }) {
    List<ParticipantModel> calculatedParticipants;

    switch (splitType) {
      case SplitType.equal:
        calculatedParticipants = calculateEqualSplit(totalAmount, participants);
        break;
      case SplitType.percentage:
        if (percentages == null) {
          throw ArgumentError('Percentages required for percentage split');
        }
        calculatedParticipants = calculatePercentageSplit(
          totalAmount,
          participants,
          percentages,
        );
        break;
      case SplitType.custom:
        if (!validateCustomAmounts(totalAmount, participants)) {
          throw ArgumentError('Custom amounts must sum to total amount');
        }
        calculatedParticipants = participants;
        break;
    }

    return SplitBillModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      totalAmount: totalAmount,
      splitType: splitType,
      createdAt: DateTime.now(),
      creatorId: creatorId,
      participants: calculatedParticipants,
    );
  }

  /// Mark a participant as paid
  SplitBillModel markAsPaid(
    SplitBillModel splitBill,
    String participantId,
    String transactionId,
  ) {
    final updatedParticipants = splitBill.participants.map((participant) {
      if (participant.id == participantId) {
        return participant.copyWith(
          hasPaid: true,
          paymentTransactionId: transactionId,
        );
      }
      return participant;
    }).toList();

    return splitBill.copyWith(participants: updatedParticipants);
  }

  /// Check if all participants have paid
  bool isBillFullyPaid(SplitBillModel splitBill) {
    return splitBill.participants.every((participant) => participant.hasPaid);
  }

  /// Get the amount owed by a specific participant
  double getAmountOwedByParticipant(
    SplitBillModel splitBill,
    String participantId,
  ) {
    final participant = splitBill.participants.firstWhere(
      (p) => p.id == participantId,
      orElse: () => ParticipantModel(
        id: '',
        name: '',
        amountOwed: 0.0,
      ),
    );
    
    return participant.amountOwed;
  }
}
