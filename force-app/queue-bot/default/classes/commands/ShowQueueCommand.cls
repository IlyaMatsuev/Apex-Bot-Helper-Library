/**
 * Created by Ilya Matsuev on 9/12/2020.
 */

public with sharing class ShowQueueCommand implements IBotCommand {

    public String answer(Map<String, String> messageInfo) {
        List<Queue__c> queues = QueueService.getRecentQueues();
        String answer = '';
        for (Queue__c queue: queues) {
            answer += queue.Subject__r.Name + ' - ' + queue.Scheduled_Date__c + '\n';
            for (Queue_Member__c member : queue.Queue_Members__r) {
                answer += member.Place__c + '. ' + member.Name + '\n';
            }
            answer += '\n';
        }
        if (queues.isEmpty()) {
            answer = 'There are no queues scheduled for tomorrow';
        }
        return answer;
    }
}
