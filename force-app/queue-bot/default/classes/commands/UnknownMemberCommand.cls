/**
 * Created by Ilya Matsuev on 9/6/2020.
 */

public with sharing class UnknownMemberCommand implements IBotCommand {

    public String answer(Map<String, String> messageInfo) {
        return 'You are not from our squad yet\nUse "/join <group> <sub-group> <password?>" to join any existing group';
    }
}
