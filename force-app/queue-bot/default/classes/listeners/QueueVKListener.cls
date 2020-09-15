/**
 * Created by Ilya Matsuev on 9/6/2020.
 */

public with sharing class QueueVKListener implements IVKBotMessageListener {

    public String getRegistrationName() {
        return 'QueueVKBot';
    }

    public void onMessage(VKBotService botService) {
        try {
            BotCommandManager commandManager = new BotCommandManager(botService.updateWrapper);
            IBotCommand command = commandManager.getCommand();
            String answer = command.answer(new Map<String, String>{
                    'message' => botService.updateWrapper.v_object.body.trim(),
                    'userId' => String.valueOf(botService.updateWrapper.v_object.user_id),
                    'name' => requestUserName(botService)
            });
            commandManager.answer(botService, answer);
        } catch(Exception error) {
            NotificationHelper.sendEmail(
                    QueueTelegramListener.class.getName(),
                    error.getMessage() + '\n\n' + error.getStackTraceString(),
                    'mirotvorec542546@gmail.com'
            );
            throw error;
        }
    }

    private String requestUserName(VKBotService service) {
        String userName = String.valueOf(service.updateWrapper.v_object.user_id);
        Callout userInfoCallout = service.getProfileInfo(userName);
        if (userInfoCallout.isSuccess()) {
            VKUserInfoResponseWrapper userInfoResponse = (VKUserInfoResponseWrapper) JSON.deserialize(
                    userInfoCallout.responseBody,
                    VKUserInfoResponseWrapper.class
            );
            if (!userInfoResponse.response.isEmpty()) {
                VKUserInfoWrapper wrapper = userInfoResponse.response.get(0);
                userName = wrapper.first_name + ' ' + wrapper.last_name;
            }
        }
        return userName;
    }
}
