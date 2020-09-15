/**
 * Created by Ilya Matsuev on 9/12/2020.
 */

public with sharing class ArgumentsParser {

    public static Map<String, String> parseCommandArgs(String commandMessage, List<String> argsNames) {
        Map<String, String> args = new Map<String, String>();
        List<String> commandArgs = commandMessage.substringAfter('/').split(' ');
        for (Integer i = 0; i < argsNames.size() && i < commandArgs.size(); i++) {
            args.put(argsNames.get(i), commandArgs.get(i));
        }
        return args;
    }
}
