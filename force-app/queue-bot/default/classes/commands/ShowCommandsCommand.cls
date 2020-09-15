/**
 * Created by Ilya Matsuev on 9/12/2020.
 */

public with sharing class ShowCommandsCommand implements IBotCommand {

    public String answer(Map<String, String> messageInfo) {
        List<String> commands = new List<String> {
                '/register <subject> <place?>',
                '/subjects',
                '/show',
                '/join <group> <sub-group> <password?>',
                '/commands'
        };
        return 'Available commands: \n' + String.join(commands, '\n');
    }
}
