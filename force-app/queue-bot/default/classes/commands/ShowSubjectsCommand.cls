/**
 * Created by Ilya Matsuev on 9/12/2020.
 */

public with sharing class ShowSubjectsCommand implements IBotCommand {

    public String answer(Map<String, String> messageInfo) {
        List<Subject__c> subjects = SubjectService.getAllSubjects();
        List<String> subjectNames = new List<String>();
        for (Subject__c subject: subjects) {
            subjectNames.add(subject.Name);
        }
        return 'Here are all subjects: \n' + String.join(subjectNames, '\n');
    }
}
