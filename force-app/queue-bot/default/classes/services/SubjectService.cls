/**
 * Created by Ilya Matsuev on 9/12/2020.
 */

public with sharing class SubjectService {

    public static List<Subject__c> getAllSubjects() {
        List<Subject__c> subjects = [
                SELECT Name
                FROM Subject__c
        ];
        return subjects;
    }
}
