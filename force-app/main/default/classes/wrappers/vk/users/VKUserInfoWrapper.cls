/**
 * Created by Ilya Matsuev on 9/15/2020.
 */

public with sharing class VKUserInfoWrapper {

    public Integer id {get;set;}
    public String first_name {get;set;}
    public String last_name {get;set;}
    public Boolean is_closed {get;set;}
    public Boolean can_access_closed {get;set;}
}
