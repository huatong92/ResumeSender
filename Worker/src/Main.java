import java.util.List;
import java.util.Map.Entry;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.profile.ProfileCredentialsProvider;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient;
import com.amazonaws.services.sqs.AmazonSQSClient;
import com.amazonaws.services.sqs.model.Message;
import com.amazonaws.services.sqs.model.ReceiveMessageRequest;

public class Main {
	public static void main(String args[]){
		try{
			AWSCredentials credentials = new ProfileCredentialsProvider("default").getCredentials();
			
			AmazonDynamoDBClient client = new AmazonDynamoDBClient(credentials);
			String myQueueUrl = "https://sqs.us-east-1.amazonaws.com/275512981344/newResume";
			
			AmazonSQSClient sqs = new AmazonSQSClient(credentials);
			ReceiveMessageRequest receiveMessageRequest = new ReceiveMessageRequest(myQueueUrl);
			List<Message> messages = sqs.receiveMessage(receiveMessageRequest).getMessages();
			for (Message message : messages) {
			    System.out.println("  Message");
			    System.out.println("    MessageId:     " + message.getMessageId());
			    System.out.println("    ReceiptHandle: " + message.getReceiptHandle());
			    System.out.println("    MD5OfBody:     " + message.getMD5OfBody());
			    System.out.println("    Body:          " + message.getBody());
			    String[] str = message.getBody().split(",");
			    
			    
			    System.out.println(message.getBody());
//			    for (Entry<String, String> entry : message.getAttributes().entrySet()) {
//			        System.out.println("  Attribute");
//			        System.out.println("    Name:  " + entry.getKey());
//			        System.out.println("    Value: " + entry.getValue());
//			    }
			}
			System.out.println();
		
		} catch (Exception e){
			System.out.println("failed");
		}
		
	}
}
