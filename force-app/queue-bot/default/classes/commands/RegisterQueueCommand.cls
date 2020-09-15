/**
 * Created by Ilya Matsuev on 9/6/2020.
 */

public with sharing class RegisterQueueCommand implements IBotCommand {

    public static final String COMMAND_PATTERN = '^/[A-Za-z]+ [A-Za-z.]*( [1-9][0-5]*)?$';

    private final List<String> COMMAND_ARGS_NAMES = new List<String> {
            'commandName',
            'subjectName',
            'queuePlace'
    };

    public String answer(Map<String, String> messageInfo) {
        String message = messageInfo.get('message');
        String userId = messageInfo.get('userId');
        String answer = '';
        if (!Pattern.matches(COMMAND_PATTERN, message)) {
            IBotCommand invalidCommand = new InvalidMessageCommand();
            return invalidCommand.answer(messageInfo);
        } else if (!QueueScheduleService.isAvailableTime()) {
            IBotCommand invalidCommand = new NotAvailableScheduleTimeCommand();
            return invalidCommand.answer(messageInfo);
        }

        Queue_Member__c queuePlace = QueueService.register(userId, ArgumentsParser.parseCommandArgs(message, COMMAND_ARGS_NAMES));
        if (queuePlace == null) {
            answer = 'There are no such queues for tomorrow';
        } else {
            answer = 'OK, your place is ' + queuePlace.Place__c;
        }
        return answer;
    }
}
