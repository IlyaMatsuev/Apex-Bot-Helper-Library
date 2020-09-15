/**
 * Created by Ilya Matsuev on 9/12/2020.
 */

public with sharing class JoinSubGroupCommand implements IBotCommand {

    private final List<String> COMMAND_ARGS_NAMES = new List<String> {
            'commandName',
            'groupName',
            'subGroupName',
            'password'
    };

    public String answer(Map<String, String> messageInfo) {
        String answer = '';
        Map<String, String> args = ArgumentsParser.parseCommandArgs(messageInfo.get('message'), COMMAND_ARGS_NAMES);
        Sub_Group__c subGroup = GroupService.getSubGroupByName(args.get('groupName'), args.get('subGroupName'));
        if (subGroup == null || subGroup.Sub_Group_Password__c != args.get('password')) {
            answer = 'Invalid group/sub-group name or the password is wrong';
        } else if (GroupService.alreadyJoined(subGroup, messageInfo.get('userId'))) {
            answer = 'You have been already joined the ' + subGroup.Name + ' sub-group of a ' + subGroup.Group__r.Name + ' group';
        } else {
            GroupService.joinGroup(subGroup, messageInfo.get('userId'), messageInfo.get('name'));
            answer = 'You have successfully joined the ' + subGroup.Name + ' sub-group of a ' + subGroup.Group__r.Name + ' group';
        }
        return answer;
    }
}
