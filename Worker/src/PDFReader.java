import java.io.*;
import java.util.*;

import org.apache.pdfbox.cos.COSDocument;
import org.apache.pdfbox.pdfparser.PDFParser;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.util.PDFTextStripper;

import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.PutItemRequest;

public class PDFReader {
	private PDFParser parser = null;
	private PDDocument pdDoc = null;
    private COSDocument cosDoc = null;
    private PDFTextStripper pdfStripper;
    private List<String> keywords;
    
    
    public PDFReader() throws IOException{
    	//BufferedReader infile = new BufferedReader(new FileReader(keywordsFile));
    	//keywords = new ArrayList<>();
    	String[] strs = {"java", "python", "html",
    			"css", 
    			"r",
    			"matlab",
    			"sas",
    			"marketing",
    			"database",
    			"accounting",
    			"french",
    			"photoshop",
    			"chinese",
    			"c++",
    			"javascript",
    			"c",
    			"illustrator",
    			"spss",
    			"spanish",
    			"stata",
    			"modeling",
    			"sales",
    			"amazon",
    			"google"
    	};
    	keywords = new ArrayList<>(Arrays.asList(strs));
    	//infile.close();
    }
    
	public String readPDF(InputStream input){
		System.out.println("Read in pdf");
		String parsedText = null;
		try{
			parser = new PDFParser(input);
		}catch (Exception e){
			System.out.println("read failed");
		}
		try{
			parser.parse();
			cosDoc = parser.getDocument();
			pdfStripper = new PDFTextStripper();
		    pdDoc = new PDDocument(cosDoc);
		    parsedText = pdfStripper.getText(pdDoc);
		}catch(Exception e){
			System.out.println("parse failed");
		}
		System.out.println("parse succeded");
		//System.out.println(parsedText);
		return parsedText;
	}
	
	public void genRecord(String text, AmazonDynamoDBClient client, String url){
		text = text.replaceAll("(?!\\+)\\p{Punct}", " ")
				.replaceAll("\n|\t", " ")
				.toLowerCase();
		//System.out.println(text);
		Map<String, AttributeValue> item = new HashMap<>();
		for (String kw:keywords){
			if (text.contains(' '+kw+' ')){
				item.put(kw, new AttributeValue().withBOOL(true));
			}else{
				item.put(kw, new AttributeValue().withBOOL(false));
			}
		}
		item.put("url", new AttributeValue().withS(url));
		PutItemRequest putItemRequest = new PutItemRequest().withTableName("ResumeSearch").withItem(item);
		client.putItem(putItemRequest);
	}
}


