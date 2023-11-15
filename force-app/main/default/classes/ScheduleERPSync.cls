public with sharing class ScheduleERPSync implements Schedulable {

    public void execute(SchedulableContext sc) {

        ERPSyncBatch batch = new ERPSyncBatch();
        database.executebatch(batch);
        
    }

}