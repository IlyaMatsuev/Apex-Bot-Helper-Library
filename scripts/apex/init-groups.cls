delete [SELECT Id FROM Group__c];
delete [SELECT Id FROM Sub_Group__c];
delete [SELECT Id FROM Group_Member__c];

Group__c fourth = new Group__c(Name = 'FIT-4-4');
insert fourth;
Sub_Group__c firstSubGroup = new Sub_Group__c(Name = '1', Group__c = fourth.Id);
Sub_Group__c secondSubGroup = new Sub_Group__c(Name = '2', Group__c = fourth.Id);
insert new Sub_Group__c[] {firstSubGroup, secondSubGroup};

List<Group_Member__c> members = new List<Group_Member__c> {
        new Group_Member__c(Name = 'Илья Мацуев', Sub_Group__c = firstSubGroup.Id),
        new Group_Member__c(Name = 'Илья Сикорский', Sub_Group__c = firstSubGroup.Id),
        new Group_Member__c(Name = 'Сергей Жугин', Sub_Group__c = firstSubGroup.Id),
        new Group_Member__c(Name = 'Егор Гончар', Sub_Group__c = firstSubGroup.Id),
        new Group_Member__c(Name = 'Роман Кукла', Sub_Group__c = firstSubGroup.Id),
        new Group_Member__c(Name = 'Кирилл Кутас', Sub_Group__c = firstSubGroup.Id),
        new Group_Member__c(Name = 'Костя Ширитон', Sub_Group__c = firstSubGroup.Id),
        new Group_Member__c(Name = 'Swatar Common', Sub_Group__c = firstSubGroup.Id),
        new Group_Member__c(Name = 'Артемий Марковский', Sub_Group__c = firstSubGroup.Id),
        new Group_Member__c(Name = 'Александр Фомин', Sub_Group__c = firstSubGroup.Id),
        new Group_Member__c(Name = 'Елизавета Бородина', Sub_Group__c = firstSubGroup.Id),
        new Group_Member__c(Name = 'Юра Карленок', Sub_Group__c = firstSubGroup.Id),
        new Group_Member__c(Name = 'Екатерина Петрович', Sub_Group__c = firstSubGroup.Id),
        new Group_Member__c(Name = 'Валентин Дубалеко', Sub_Group__c = firstSubGroup.Id)
};
insert members;

List<Subject__c> subjects = new List<Subject__c> {
        new Subject__c(Name = '.net'),
        new Subject__c(Name = 'java')
};
insert subjects;
List<Queue__c> queuesMonday = new List<Queue__c>();
Datetime startClassesDate = Datetime.newInstance(2020, 9, 7, 8, 0, 0);
for (Subject__c subject: subjects) {
    queuesMonday.add(new Queue__c(
            Name = String.valueOf(startClassesDate.date()) + '-' + subject.Name,
            Scheduled_Date__c = startClassesDate,
            Subject__c = subject.Id
    ));
    startClassesDate = startClassesDate.addMinutes(110);
}
insert queuesMonday;
