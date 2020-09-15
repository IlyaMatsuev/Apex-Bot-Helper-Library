/**
 * Created by Ilya Matsuev on 9/6/2020.
 */

public with sharing class GroupService {

    private static final Map<String, Group_Member__c> CASHED_MEMBERS_MAP = new Map<String, Group_Member__c>();


    public static Group_Member__c getMemberByUserId(String userId) {
        Group_Member__c member = CASHED_MEMBERS_MAP.get(userId);
        if (member == null) {
            List<Group_Member__c> members = [
                    SELECT Id, Name, Sub_Group__c
                    FROM Group_Member__c
                    WHERE Telegram_Username__c = :userId
                    OR VK_Username__c = :userId
                    LIMIT 1
            ];
            if (!members.isEmpty()) {
                member = members.get(0);
                CASHED_MEMBERS_MAP.put(userId, member);
            }
        }
        return member;
    }

    public static Sub_Group__c getSubGroupByName(String groupName, String subGroupName) {
        List<Sub_Group__c> subGroups = [
                SELECT Name, Sub_Group_Password__c, Group__r.Name
                FROM Sub_Group__c
                WHERE Group__r.Name = :groupName
                AND Name = :subGroupName
                LIMIT 1
        ];
        Sub_Group__c subGroup = null;
        if (!subGroups.isEmpty()) {
            subGroup = subGroups.get(0);
        }
        return subGroup;
    }

    public static Boolean alreadyJoined(Sub_Group__c subGroup, String userId) {
        Boolean hasSuchGroupMember = [
                SELECT COUNT()
                FROM Group_Member__c
                WHERE Sub_Group__c = :subGroup.Id
                AND (Telegram_Username__c = :userId OR VK_Username__c = :userId)
        ] > 0;
        return hasSuchGroupMember;
    }

    public static Group_Member__c joinGroup(Sub_Group__c subGroup, String userId, String name) {
        Group_Member__c newMember = new Group_Member__c(
                Name = name,
                Sub_Group__c = subGroup.Id
        );
        if (BotCommandManager.commandContext == BotCommandContext.TELEGRAM) {
            newMember.Telegram_Username__c = userId;
        } else if (BotCommandManager.commandContext == BotCommandContext.VK) {
            newMember.VK_Username__c = userId;
        }
        insert newMember;
        return newMember;
    }
}
