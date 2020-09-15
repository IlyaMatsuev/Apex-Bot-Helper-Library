/**
 * Created by Ilya Matsuev on 9/6/2020.
 */

public with sharing class InvalidMessageCommand implements IBotCommand {

    public String answer(Map<String, String> messageInfo) {
        IBotCommand commandsListCommand = new ShowCommandsCommand();
        return '))\n' + commandsListCommand.answer(messageInfo);
    }
}
