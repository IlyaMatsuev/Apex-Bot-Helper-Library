/**
 * Created by Ilya Matsuev on 9/6/2020.
 */

public with sharing class QueueTelegramListener implements ITelegramBotMessageListener {

    public String getRegistrationName() {
        return 'QueueTelegramBot';
    }

    public void onMessage(TelegramBotService botService) {
        try {
            if (botService.updateWrapper.message == null) {
                return;
            }

            BotCommandManager commandManager = new BotCommandManager(botService.updateWrapper);
            IBotCommand command = commandManager.getCommand();
            String answer = command.answer(new Map<String, String>{
                    'message' => botService.updateWrapper.message.text.trim(),
                    'userId' => String.valueOf(botService.updateWrapper.message.v_from.id),
                    'name' => botService.updateWrapper.message.v_from.first_name + ' ' + botService.updateWrapper.message.v_from.last_name
            });
            commandManager.answer(botService, answer);
        } catch (Exception error) {
            NotificationHelper.sendEmail(
                    QueueTelegramListener.class.getName(),
                    error.getMessage() + '\n\n' + error.getStackTraceString(),
                    'mirotvorec542546@gmail.com'
            );
            throw error;
        }
    }
}
