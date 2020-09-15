/**
 * Created by Ilya Matsuev on 9/15/2020.
 */

public with sharing class QueueScheduleService {

    public static Boolean isAvailableTime() {
        String scheduleName = 'QueueBotRegistrationSchedule';
        List<BusinessHours> hours = [
                SELECT Id
                FROM BusinessHours
                WHERE Name = :scheduleName
                LIMIT 1
        ];
        return !hours.isEmpty() && BusinessHours.isWithin(hours.get(0).Id, System.now());
    }
}
