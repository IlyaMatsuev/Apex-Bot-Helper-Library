/**
 * Created by Ilya Matsuev on 9/6/2020.
 */

public with sharing class EmptyMessageCommand implements IBotCommand {

    public String answer(Map<String, String> messageInfo) {
        return 'I don\'t support non-text messages yet';
    }
}
