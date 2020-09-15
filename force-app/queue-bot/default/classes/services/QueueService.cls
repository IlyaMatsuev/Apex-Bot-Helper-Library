/**
 * Created by Ilya Matsuev on 9/6/2020.
 */

public with sharing class QueueService {

    public static Queue_Member__c register(String userId, Map<String, String> args) {
        String subject = args.get('subjectName');
        String place = args.get('queuePlace');
        Queue__c queue = getQueueBySubject(subject);
        if (queue == null) {
            return null;
        }
        Group_Member__c groupMember = GroupService.getMemberByUserId(userId);
        Queue_Member__c newQueueMember = getQueueMember(groupMember, queue);

        newQueueMember.Place__c = getQueuePlace(place == null ? null : Integer.valueOf(place), queue.Queue_Members__r);
        upsert newQueueMember;
        return newQueueMember;
    }

    public static List<Queue__c> getRecentQueues() {
        List<Queue__c> queues = [
                SELECT Id, Name, Subject__c, Subject__r.Name, Scheduled_Date__c,
                (SELECT Id, Name, Group_Member__c, Place__c FROM Queue_Members__r ORDER BY Place__c)
                FROM Queue__c
                WHERE DAY_ONLY(Scheduled_Date__c) = TOMORROW
        ];
        return queues;
    }

    public static Queue__c getQueueBySubject(String subject) {
        List<Queue__c> queues = [
                SELECT Id, Name, Subject__c, Scheduled_Date__c,
                    (SELECT Id, Name, Group_Member__c, Place__c FROM Queue_Members__r ORDER BY Place__c)
                FROM Queue__c
                WHERE Subject__r.Name = :subject
                AND DAY_ONLY(Scheduled_Date__c) = TOMORROW
                LIMIT 1
        ];
        Queue__c queue = null;
        if (!queues.isEmpty()) {
            queue = queues.get(0);
        }
        return queue;
    }


    private static Integer getQueuePlace(Integer preferredPlace, List<Queue_Member__c> queueMembers) {
        Integer actualPlace = null;
        if (preferredPlace == null) {
            for (Integer i = 0; i < queueMembers.size(); i++) {
                Integer iterationPlace = queueMembers.get(i).Place__c.intValue();
                if (i + 1 != iterationPlace) {
                    actualPlace = i + 1;
                    break;
                }
            }
            if (actualPlace == null) {
                if (queueMembers.isEmpty()) {
                    actualPlace = 1;
                } else {
                    actualPlace = queueMembers.size() + 1;
                }
            }
        } else {
            Integer availablePlace = preferredPlace;
            for (Queue_Member__c member: queueMembers) {
                if (member.Place__c == availablePlace) {
                    availablePlace++;
                }
            }
            actualPlace = availablePlace;
        }
        return actualPlace;
    }

    private static Queue_Member__c getQueueMember(Group_Member__c groupMember, Queue__c queue) {
        Queue_Member__c queueMember = null;
        for (Queue_Member__c member: queue.Queue_Members__r) {
            if (member.Name == groupMember.Name) {
                queueMember = member;
            }
        }
        if (queueMember == null) {
            queueMember = new Queue_Member__c(
                    Name = groupMember.Name,
                    Group_Member__c = groupMember.Id,
                    Queue__c = queue.Id
            );
        }
        return queueMember;
    }
}
