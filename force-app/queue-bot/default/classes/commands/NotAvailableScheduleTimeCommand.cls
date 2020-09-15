/**
 * Created by Ilya Matsuev on 9/7/2020.
 */

public with sharing class NotAvailableScheduleTimeCommand implements IBotCommand {

    public String answer(Map<String, String> messageInfo) {
        return 'Not yet';
    }
}
