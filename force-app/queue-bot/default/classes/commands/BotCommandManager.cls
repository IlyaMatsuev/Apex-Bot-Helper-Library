/**
 * Created by Ilya Matsuev on 9/6/2020.
 */

public with sharing class BotCommandManager {

    public static BotCommandContext commandContext { get; private set; }

    private final Map<QueueCommand, IBotCommand> QUEUE_COMMANDS_MAP = new Map<QueueCommand, IBotCommand>{
            QueueCommand.REGISTER => new RegisterQueueCommand(),
            QueueCommand.SHOW_QUEUE => new ShowQueueCommand(),
            QueueCommand.SHOW_SUBJECTS => new ShowSubjectsCommand(),
            QueueCommand.SHOW_COMMANDS => new ShowCommandsCommand(),
            QueueCommand.JOIN_SUB_GROUP => new JoinSubGroupCommand(),
            QueueCommand.INVALID => new InvalidMessageCommand()
    };

    private final Map<String, QueueCommand> QUEUE_COMMANDS_BY_NAME = new Map<String, QueueCommand>{
            'register' => QueueCommand.REGISTER,
            'show' => QueueCommand.SHOW_QUEUE,
            'subjects' => QueueCommand.SHOW_SUBJECTS,
            'commands' => QueueCommand.SHOW_COMMANDS,
            'join' => QueueCommand.JOIN_SUB_GROUP
    };

    private String message { get; set; }
    private TelegramUpdateWrapper telegramUpdateWrapper { get; set; }
    private VKNewMessageResponseWrapper vkUpdateWrapper { get; set; }

    public BotCommandManager(TelegramUpdateWrapper updateWrapper) {
        if (updateWrapper != null && updateWrapper.message != null) {
            this.message = updateWrapper.message.text;
        }
        this.telegramUpdateWrapper = updateWrapper;
        commandContext = BotCommandContext.TELEGRAM;
    }

    public BotCommandManager(VKNewMessageResponseWrapper updateWrapper) {
        if (updateWrapper != null && updateWrapper.v_object != null) {
            this.message = updateWrapper.v_object.body;
        }
        this.vkUpdateWrapper = updateWrapper;
        commandContext = BotCommandContext.VK;
    }


    public IBotCommand getCommand() {
        IBotCommand command = validateCommandMessage(message);
        if (command == null) {
            QueueCommand commandName = evaluateCommandByMessage(message);
            command = QUEUE_COMMANDS_MAP.get(commandName);
        }
        return command;
    }

    public void answer(TelegramBotService telegramBotService, String answer) {
        answer(commandContext.name(), JSON.serialize(telegramBotService), answer);
    }

    public void answer(VKBotService vkBotService, String answer) {
        answer(commandContext.name(), JSON.serialize(vkBotService), answer);
    }

    @future(callout=true)
    private static void answer(String contextCommand, String serializedService, String answer) {
        if (contextCommand == BotCommandContext.TELEGRAM.name()) {
            TelegramBotService botService = (TelegramBotService) JSON.deserialize(serializedService, TelegramBotService.class);
            botService.sendMessage(answer);
        } else if (contextCommand == BotCommandContext.VK.name()) {
            VKBotService botService = (VKBotService) JSON.deserialize(serializedService, VKBotService.class);
            botService.sendMessage(answer);
        }
    }

    private QueueCommand evaluateCommandByMessage(String message) {
        String commandName = '';
        if (String.isNotBlank(message)) {
            commandName = message.substringAfter('/').split(' ').get(0);
        }
        QueueCommand command = QUEUE_COMMANDS_BY_NAME.get(commandName);
        if (command == null) {
            command = QueueCommand.INVALID;
        }
        return command;
    }

    private IBotCommand validateCommandMessage(String message) {
        IBotCommand command = null;
        Group_Member__c member = null;
        QueueCommand commandName = evaluateCommandByMessage(message);
        if (commandContext == BotCommandContext.TELEGRAM && telegramUpdateWrapper != null && telegramUpdateWrapper.message != null) {
            member = GroupService.getMemberByUserId(String.valueOf(telegramUpdateWrapper.message.v_from.id));
        } else if (commandContext == BotCommandContext.VK && vkUpdateWrapper != null && vkUpdateWrapper.v_object != null) {
            member = GroupService.getMemberByUserId(String.valueOf(vkUpdateWrapper.v_object.user_id));
        }

        if (String.isBlank(message)) {
            command = new EmptyMessageCommand();
        }if (member == null && commandName != QueueCommand.JOIN_SUB_GROUP) {
            command = new UnknownMemberCommand();
        }
        return command;
    }
}
