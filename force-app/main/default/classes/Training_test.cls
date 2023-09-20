@isTest
private class Training_test {

@isTest
    static void test_method_Task_01(){
        List<Restaurant__c> restaurants = new List<Restaurant__c>();
        List<Training__c> trainings = new List<Training__c>();
        Restaurant__c restaurant = new Restaurant__c();
        restaurant.Name = 'Test restaurant';
        restaurant.Comission_Rate__c = 10;
        restaurant.Average_Meal_Cost__c = 20;
        Restaurant__c restaurant2 = new Restaurant__c();
        restaurant2.Name = 'Test restaurant 2';
        restaurant2.Comission_Rate__c = 20;
        restaurant2.Average_Meal_Cost__c = 30;
        restaurants.add(restaurant);
        restaurants.add(restaurant2);
        insert restaurants;
        Training__c training = new Training__c();   
        training.name = 'SF test Class';
        training.Restaurant__c = restaurants[0].id;
        training.Start_Date__c = Date.newinstance(2023, 09, 13);
        training.End_Date__c = Date.newInstance(2023,09,18);
        training.Number_of_Participants__c = 10;
        Training__c training2 = new Training__c();
        training2.name = 'SF test Class 2';
        training2.Restaurant__c = restaurants[1].id;
        training2.Start_Date__c = Date.newinstance(2023, 09, 11);
        training2.End_Date__c = Date.newInstance(2023,09,23);
        training2.Number_of_Participants__c = 50;
        trainings.add(training);
        trainings.add(training2);
        Test.startTest();
        Database.insert(trainings,false);
        Test.stopTest();
        List<Task> task = [Select Id, Subject from Task];
        System.assertEquals(2, task.size());
    }

    @isTest
    static void test_method_ForecastCalculate_02(){
        List<Decimal> nums = new List<Decimal>();
        List<Restaurant__c> restaurants = new List<Restaurant__c>();
        List<Training__c> trainings = new List<Training__c>();
        Restaurant__c restaurant = new Restaurant__c();
        restaurant.Name = 'Test restaurant';
        restaurant.Comission_Rate__c = 10;
        restaurant.Average_Meal_Cost__c = 20;
        Restaurant__c restaurant2 = new Restaurant__c();
        restaurant2.Name = 'Test restaurant 2';
        restaurant2.Comission_Rate__c = 20;
        restaurant2.Average_Meal_Cost__c = 30;
        restaurants.add(restaurant);
        restaurants.add(restaurant2);
        insert restaurants;
        Training__c training = new Training__c();   
        training.name = 'SF test Class';
        training.Restaurant__c = restaurants[0].id;
        training.Start_Date__c = Date.newinstance(2023, 09, 13);
        training.End_Date__c = Date.newInstance(2023,09,18);
        training.Number_of_Participants__c = 10;
        Training__c training2 = new Training__c();
        training2.name = 'SF test Class 2';
        training2.Restaurant__c = restaurants[1].id;
        training2.Start_Date__c = Date.newinstance(2023, 09, 11);
        training2.End_Date__c = Date.newInstance(2023,09,23);
        training2.Number_of_Participants__c = 50;
        trainings.add(training);
        trainings.add(training2);
        Test.startTest();
        Database.insert(trainings,false);
        Test.stopTest();
        List<Training__c> insertedTrainings = [Select Id, Name, Restaurant_Commission_Forecast__c From Training__c ];
        System.assertEquals(4000, insertedTrainings[0].Restaurant_Commission_Forecast__c);
        System.assertEquals(144000, insertedTrainings[1].Restaurant_Commission_Forecast__c);
    }
}






    
