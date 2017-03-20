#include "stdio.h"
#include "mopush.h"
#include "string.h"
#include "mosquitto.h"
#include "time.h"
#include <stdlib.h>

#define MOPUSH_LEN 4
#define MOPUSH_TYPE_LEN 4
#define MOPUSH_DATE_LEN 19
#define MOPUSH_CIRCLE_PAYLOAD_LEN 500

char clientName[50]="";
char topicListFile[20]="topicList.txt";
char logFile[20]="mopushlog.txt";
void (*new_message)(mopush *mosq, void *, mopush_message *);
char mpushPayLoad[MPUSH_MAX_PAYLOAD_LEN];

int encapayload(mopush *mpush, int len, char *payload, int type)
{
    int headLen=0;
    int mpushLen=0;
   
    char *clientId=mosquitto_get_local_clientid(mpush);
    time_t now;
    struct tm *timenow;
    char dateTime[MPUSH_MAX_DATE_LEN];
    char strLog[100];
    if(!mpush)
    {
       sprintf(strLog,"%s\r\n","mpush is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    } 
    if(!payload)
    {
       sprintf(strLog,"%s\r\n","payload is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }            
    time(&now);
    timenow = localtime(&now);
    
    sprintf(dateTime,"%4d-%02d-%02d %02d/%02d/%02d",timenow->tm_year+1900,timenow->tm_mon+1,timenow->tm_mday,timenow->tm_hour,timenow->tm_min,timenow->tm_sec);
  

    headLen +=  MOPUSH_LEN;
    headLen +=  MOPUSH_TYPE_LEN;
    headLen +=  MOPUSH_DATE_LEN;
    headLen +=  strlen(clientId);
   // printf("clientid=%s,headlen=%d\n",clientId,headLen);
    mpushPayLoad[0]=(headLen&0xff000000) >> 24;
    mpushPayLoad[1]=(headLen&0xff0000) >> 16;
    mpushPayLoad[2]=(headLen&0xff00) >> 8;
    mpushPayLoad[3]=headLen&0xff;

    mpushPayLoad[4]=(type&0xff000000) >> 24;
    mpushPayLoad[5]=(type&0xff0000) >> 16;
    mpushPayLoad[6]=(type&0xff00) >> 8;
    mpushPayLoad[7]=type&0xff;   

    strcpy(&mpushPayLoad[MOPUSH_LEN+MOPUSH_TYPE_LEN],dateTime);
    strcpy(&mpushPayLoad[MOPUSH_LEN+MOPUSH_TYPE_LEN+strlen(dateTime)],clientId);
    memcpy(&mpushPayLoad[headLen],payload,len);
    
    mpushLen=headLen+len;
    return(mpushLen);
}

int mopush_internal_publish(mopush *mpush, const char *topic, int payloadlen, const void *payload, int qos, bool retain, int type)
{
  int result=0;
  int mid;
  char *clientId;    
  unsigned int mpushLen=0,tmpLen=0;
  unsigned int headLen=0;
  char mpushPayLoad[MPUSH_MAX_PAYLOAD_LEN];
  char dateTime[MPUSH_MAX_DATE_LEN];
  int i;
  time_t now;
  struct tm *timenow;
  char newTopic[MPUSH_MAX_TOPIC_LEN];
  char *tmpPtr=(char *)payload;
  
    if(!mpush || !topic || qos<0 || qos>2) return MPUSH_ERR_INVAL;
    
    if(strlen(topic) == 0) return MPUSH_ERR_INVAL;
  
    clientId=mosquitto_get_local_clientid(mpush);
    
    time(&now);
    timenow = localtime(&now);
    
    sprintf(dateTime,"%4d-%02d-%02d %02d/%02d/%02d",timenow->tm_year+1900,timenow->tm_mon+1,timenow->tm_mday,timenow->tm_hour,timenow->tm_min,timenow->tm_sec);
   // dateTime=asctime(timenow);
    
/*
    for(i=0;i<payloadlen;i++)
        printf("tmp[%d]=%c\n",i,tmpPtr[i]);
*/
    headLen +=  MOPUSH_LEN;
    headLen +=  MOPUSH_TYPE_LEN;
    headLen +=  MOPUSH_DATE_LEN;
    headLen +=  strlen(clientId);
   // printf("clientid=%s,headlen=%d\n",clientId,headLen);
    mpushPayLoad[0]=(headLen&0xff000000) >> 24;
    mpushPayLoad[1]=(headLen&0xff0000) >> 16;
    mpushPayLoad[2]=(headLen&0xff00) >> 8;
    mpushPayLoad[3]=headLen&0xff;

    mpushPayLoad[4]=(type&0xff000000) >> 24;
    mpushPayLoad[5]=(type&0xff0000) >> 16;
    mpushPayLoad[6]=(type&0xff00) >> 8;
    mpushPayLoad[7]=type&0xff;   

//    文件名长度 文件名 文件长度 文件
//    abc.jpg
//    7 abc.jpg 134567 payload
//    
//    type==100 文件
//    write（abc.mpush3 ,payload)
    
    strcpy(&mpushPayLoad[MOPUSH_LEN+MOPUSH_TYPE_LEN],dateTime);
    strcpy(&mpushPayLoad[MOPUSH_LEN+MOPUSH_TYPE_LEN+strlen(dateTime)],clientId);
    memcpy(&mpushPayLoad[headLen],tmpPtr,payloadlen);
    
    mpushLen=headLen+payloadlen;
    /*
    for(i=0;i<4;i++)
      printf("mpushpayloadlen[%d]=0x%x\n",i,mpushPayLoad[i]);

    for(i=4;i<8;i++)
      printf("mpushpayloadlen[%d]=0x%x\n",i,mpushPayLoad[i]);

    for(i=8;i<mpushLen;i++)
      printf("222mpushpayload[%d]=%c\n",i,mpushPayLoad[i]);
    */      
    
 
    result=mosquitto_publish(mpush, &mid, topic, mpushLen, mpushPayLoad, qos, retain);

    if(result != MPUSH_ERR_SUCCESS)
    {
       char strLog[100];
       sprintf(strLog,"%s:%d\r\n","publish error ret code",result);
       record_error_log(strLog);
    }
    return result;
}

int mopush_internal_publish_file(mopush *mpush, const char *topic, const char *filename, int qos, bool retain)
{
    int result=0;
    int mid;
    char *clientId;
    unsigned int mpushLen=0,tmpLen=0;
    unsigned int headLen=0;
    char *mpushPayLoad;
    char dateTime[MPUSH_MAX_DATE_LEN];
    int i=0;
    time_t now;
    struct tm *timenow;
    char newTopic[MPUSH_MAX_TOPIC_LEN];
    //  char *tmpPtr=(char *)payload;
    int type=MOPUSH_TYPE_PUBLISH_FILE;
    long pos, rlen;
    char *pureFileName[100];
    char filenamecpy[200];
    FILE *fptr = NULL;
    char *saveptr = NULL;
    int filelen=0;
    
    
    if(!mpush || !topic || !filename || qos<0 || qos>2) return MPUSH_ERR_INVAL;
    
    if(strlen(topic) == 0) return MPUSH_ERR_INVAL;
    
    if(strlen(filename)>200)
    {
        printf("file name is too much \n");
        return MPUSH_ERR_INVAL;
    }
    fptr = fopen(filename, "rb");
    if(!fptr){
        //if(!quiet) fprintf(stderr, "Error: Unable to open file \"%s\".\n", filename);
        return MPUSH_ERR_INVAL;
    }
    
    fseek(fptr, 0, SEEK_END);
    filelen = ftell(fptr);
    //	printf("file len =%d\n",filelen);
    if(filelen> MAX_FILE_LEN || filelen <=0 )
    {
        fclose(fptr);
        printf("file length is more than 5M or zero\n");
        return MPUSH_ERR_INVAL;
    }
    fseek(fptr, 0, SEEK_SET);
    
    //  printf("filename=%s\n",filename);
    strcpy(filenamecpy,filename);
    pureFileName[i] = strtok_r(filenamecpy, "/", &saveptr);
    
    while(pureFileName[i] )
    {
        i++;
        pureFileName[i] = strtok_r(NULL, "/", &saveptr);
    }
    
    if(i<1)
    {
        i=0;
        pureFileName[i]=filenamecpy;
        //	return MPUSH_ERR_INVAL;
    }
    else
    {
        i--;
    }
    
    clientId=mosquitto_get_local_clientid(mpush);
    
    time(&now);
    timenow = localtime(&now);
    
    sprintf(dateTime,"%4d-%02d-%02d %02d/%02d/%02d",timenow->tm_year+1900,timenow->tm_mon+1,timenow->tm_mday,timenow->tm_hour,timenow->tm_min,timenow->tm_sec);
    // dateTime=asctime(timenow);
    
    /*
     for(i=0;i<payloadlen;i++)
     printf("tmp[%d]=%c\n",i,tmpPtr[i]);
     */
    headLen +=  MOPUSH_LEN;
    headLen +=  MOPUSH_TYPE_LEN;
    headLen +=  MOPUSH_DATE_LEN;
    headLen +=  strlen(clientId);
    
    mpushPayLoad=(char *)malloc(headLen+4+strlen(pureFileName[i])+filelen);
    
    if(mpushPayLoad == NULL)
    {
        printf("file length is more than 5M or zero\n");
        return MPUSH_ERR_INVAL;
    }
    
    // printf("clientid=%s,headlen=%d\n",clientId,headLen);
    mpushPayLoad[0]=(headLen&0xff000000) >> 24;
    mpushPayLoad[1]=(headLen&0xff0000) >> 16;
    mpushPayLoad[2]=(headLen&0xff00) >> 8;
    mpushPayLoad[3]=headLen&0xff;
    
    mpushPayLoad[4]=(type&0xff000000) >> 24;
    mpushPayLoad[5]=(type&0xff0000) >> 16;
    mpushPayLoad[6]=(type&0xff00) >> 8;
    mpushPayLoad[7]=type&0xff;
    
    strcpy(&mpushPayLoad[MOPUSH_LEN+MOPUSH_TYPE_LEN],dateTime);
    strcpy(&mpushPayLoad[MOPUSH_LEN+MOPUSH_TYPE_LEN+strlen(dateTime)],clientId);
    mpushPayLoad[headLen+0]=(strlen(pureFileName[i])&0xff000000) >> 24;
    mpushPayLoad[headLen+1]=(strlen(pureFileName[i])&0xff0000) >> 16;
    mpushPayLoad[headLen+2]=(strlen(pureFileName[i])&0xff00) >> 8;
    mpushPayLoad[headLen+3]=strlen(pureFileName[i])&0xff;
    strcpy(&mpushPayLoad[headLen+4],pureFileName[i]);
    //mpushPayLoad[headLen+4]
    
 	  pos = 0;
    while(pos < filelen){
        rlen = fread(&mpushPayLoad[headLen+4+strlen(pureFileName[i])+pos], sizeof(char), filelen-pos, fptr);
        pos += rlen;
    }
    
    // memcpy(&mpushPayLoad[headLen+4+strlen(filename)],tmpPtr,payloadlen);
    
    mpushLen=headLen+4+strlen(pureFileName[i])+filelen;
    
    /*
     for(i=0;i<4;i++)
     printf("mpushpayloadlen[%d]=0x%x\n",i,mpushPayLoad[i]);
     
     for(i=4;i<8;i++)
     printf("mpushpayloadlen[%d]=0x%x\n",i,mpushPayLoad[i]);
     
     for(i=8;i<mpushLen;i++)
     printf("222mpushpayload[%d]=%c\n",i,mpushPayLoad[i]);
     */
    
    
    result=mosquitto_publish(mpush, &mid, topic, mpushLen, mpushPayLoad, qos, retain);
    free(mpushPayLoad);

    if(result != MPUSH_ERR_SUCCESS)
    {
        char strLog[100];
        sprintf(strLog,"%s:%d\r\n","publish error ret code",result);
        record_error_log(strLog);
    }
    return result;
}


int mopush_internal_subscribe(mopush *mpush, int *mid, const char *sub, int qos)
{
    FILE *sp ;
    char topic[MPUSH_MAX_TOPIC_LEN];
    char newTopic[MPUSH_MAX_TOPIC_LEN];
    char existedTopic[MPUSH_MAX_TOPIC_NUM*MPUSH_MAX_TOPIC_LEN];
    char *newSingletopic[MPUSH_MAX_TOPIC_NUM];
    char *saveptr = NULL;
    int i=0;
    bool WrTopic=true;
    int result=0;
    char strLog[100];
    if(!mpush)
    {
       sprintf(strLog,"%s\r\n","mpush is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }
    if(!mid)
    {
       sprintf(strLog,"%s\r\n","mid is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }  
    if(!sub)
    {
       sprintf(strLog,"%s\r\n","topic is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }          
    if(mopush_invalid_char((char *)sub) !=0)
      return -1;    

    sprintf(topic,"%s:%d",sub,qos);
/*
    if((sp = fopen(topicListFile,"a+")) == NULL)
       return -1;
    
    fseek(sp,0L,SEEK_SET);     
    fgets(existedTopic,MPUSH_MAX_TOPIC_NUM*MPUSH_MAX_TOPIC_LEN,sp); 
    //printf("all topic=%s\n",existedTopic);
     
    newSingletopic[i] = strtok_r(existedTopic, ";", &saveptr);
    while(newSingletopic[i] )
    {
        //if(debug_prn)
           printf("___newSingletopic[%d]=%s,___topic=%s\n",i,newSingletopic[i],topic);
        if(strcmp(newSingletopic[i],topic) == 0)//if find same topic and qos,do nothing
        {
            printf(" it is equal\n");
            WrTopic=false;
            break;
        }
 
        if(strncmp(newSingletopic[i],sub,strlen(sub)) == 0)//if find same topic,but qos is not same ,modify qos
        {
          printf("same topic , not same qos\n");
        }
 
        i++;
        newSingletopic[i] = strtok_r(NULL, ";", &saveptr);
    }

printf("____wrtopic=%d\n",WrTopic);
    if(WrTopic == true)
    {
        strcat(topic,";");
        fwrite(topic, strlen(topic),1,sp);
        fclose(sp); 
     
//        return result; 
    } 
  //  else
   // {
*/
        result=mosquitto_subscribe(mpush, mid, sub, qos);       
       
       
       return result;
   // }
}


 int mopush_inernal_unsubscribe(mopush *mpush, int *mid, const char *sub)
{
    FILE *sp ;
    char existedTopic[MPUSH_MAX_TOPIC_NUM*MPUSH_MAX_TOPIC_LEN];
    char newTopic[MPUSH_MAX_TOPIC_NUM*MPUSH_MAX_TOPIC_LEN];
    char headTopic[MPUSH_MAX_TOPIC_LEN];
    char *oldSingletopic[MPUSH_MAX_TOPIC_NUM];
    char *saveptr = NULL;
    int i=0,newTopicNum=0;
    int delItemIndex=-1;
    int tmpIdx=0;
    char strLog[100];
    if(!mpush)
    {
       sprintf(strLog,"%s\r\n","mpush is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }
    if(!mid)
    {
       sprintf(strLog,"%s\r\n","mid is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }  
    if(!sub)
    {
       sprintf(strLog,"%s\r\n","topic is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }   
    
    if(mopush_invalid_char((char *)sub) !=0)
      return -1;
/*
    if((sp = fopen(topicListFile,"a+")) == NULL)
       return 0;
    
    fseek(sp,0L,SEEK_SET);     
    fscanf(sp,"%s",existedTopic); 
    //printf("all topic=%s\n",existedTopic);
     
    oldSingletopic[i] = strtok_r(existedTopic, ";", &saveptr);
    newTopic[0]='\0';

    while(oldSingletopic[i] )
    {
        //if(debug_prn)
        //    printf("oldSingletopic[%d]=%s\n",i,oldSingletopic[i]);
        
        if(strncmp(oldSingletopic[i],sub,strlen(sub)) !=0)
        {
            strcat(newTopic,oldSingletopic[i]);
            strcat(newTopic,";");
            newTopicNum++;
        }
        i++;
        oldSingletopic[i] = strtok_r(NULL, ";", &saveptr);
    }    
    fclose(sp); 
    remove(topicListFile);
 
    for(tmpIdx=0;tmpIdx<i;tmpIdx++)
       printf("old topic =%s\n",oldSingletopic[tmpIdx]);
    
   // for(int tmpIdx=0;tmpIdx<topicNum;tmpIdx++)
       printf("new topic =%s\n",newTopic);
 
    if(newTopicNum != i && newTopicNum >0)
    {
      FILE *spNew ;
      if((spNew = fopen(topicListFile,"a+")) == NULL)
        return 0;
        
      fwrite(newTopic, strlen(newTopic),1,spNew);
      fclose(sp);
    }
    
*/
    int result=mosquitto_unsubscribe(mpush,mid,sub);
        
    return result;
}


int mopush_lib_init(void)
{
  mosquitto_lib_init();
  return MPUSH_ERR_SUCCESS;
}

const char *mopush_strerror(int mpush_errno)
{
    return mosquitto_strerror(mpush_errno);
}

int record_error_log(char *str)
{
    FILE *sp ;
    char topic[MPUSH_MAX_TOPIC_LEN];
    char existedTopic[MPUSH_MAX_TOPIC_NUM*MPUSH_MAX_TOPIC_LEN];
    char *newSingletopic[MPUSH_MAX_TOPIC_NUM];
    char *saveptr = NULL;
    int i=0;
    bool WrTopic=true;
    int result=0;

    char dateTime[MPUSH_MAX_DATE_LEN];
  
    time_t now;
    struct tm *timenow;
    
 
    time(&now);
    timenow = localtime(&now);
    
    sprintf(dateTime,"%4d-%02d-%02d %02d/%02d/%02d:",timenow->tm_year+1900,timenow->tm_mon+1,timenow->tm_mday,timenow->tm_hour,timenow->tm_min,timenow->tm_sec);    
    if(!str)
      return -1;
/*
    if((sp = fopen(logFile,"a+")) == NULL)
       return -1;
    
    fwrite(dateTime, strlen(dateTime),1,sp);
    fwrite(str, strlen(str),1,sp);
    fclose(sp);
 */
    return 0;

}



int mopush_invalid_char(const char *charStr)
{
  
  if(!charStr)
  { 
     printf("invalid string \n");
     record_error_log("invalid string\r\n");
     return -1;
  }
  
  if( strchr(charStr,':') != NULL || strchr(charStr,';') != NULL || strchr(charStr,' ') != NULL)
  {
        printf(" the string should not include ':',';' and space \n");
        record_error_log("invalid string \n");
        return -1;
  }
  return 0;
}



int mopush_publish(mopush *mpush, const char *topic, int payloadlen, const void *payload, int qos, bool retain)
{
     char strLog[100];
     char newTopic[MPUSH_MAX_TOPIC_LEN];

    if(!mpush)
    {
       sprintf(strLog,"%s\r\n","mpush is null");
       record_error_log(strLog);
       return -1;
    }

    if(!topic)
    {
       sprintf(strLog,"%s\r\n","topic is null");
       record_error_log(strLog);
       return -1;
    }

    if(!payload)
    {
       sprintf(strLog,"%s\r\n","payload is null");
       record_error_log(strLog);
       return -1;
    }


    if(mopush_invalid_char((char *)topic) !=0)
      return -1;
    
    strcpy(newTopic,topic_base);
    strcat(newTopic,clientName);
    strcat(newTopic,"/");
    strcat(newTopic,topic);
    
    return mopush_internal_publish(mpush, newTopic,payloadlen,payload,qos,false,MOPUSH_TYPE_PUBLISH_NORMAL);

}

int mopush_subscribe(mopush *mpush, int *mid, const char *sub, int qos)
{
     char strLog[100];
     char newTopic[MPUSH_MAX_TOPIC_LEN];

    if(!mpush)
    {
       sprintf(strLog,"%s\r\n","mpush is null");
       record_error_log(strLog);
       return -1;
    }

    if(!mid)
    {
       sprintf(strLog,"%s\r\n","mid is null");
       record_error_log(strLog);
       return -1;
    }

    if(!sub)
    {
       sprintf(strLog,"%s\r\n","sub is null");
       record_error_log(strLog);
       return -1;
    }

    strcpy(newTopic,topic_base);
    strcat(newTopic,clientName);
    strcat(newTopic,"/");
    strcat(newTopic,sub);
    
    if(mopush_invalid_char((char *)sub) !=0)
      return -1;
    return mopush_internal_subscribe(mpush, mid,newTopic,qos);

}

int mopush_unsubscribe(mopush *mpush, int *mid, const char *sub)
{
     char strLog[100];
     char newTopic[MPUSH_MAX_TOPIC_LEN];

    if(!mpush)
    {
       sprintf(strLog,"%s\r\n","mpush is null");
       record_error_log(strLog);
       return -1;
    }

    if(!mid)
    {
       sprintf(strLog,"%s\r\n","mid is null");
       record_error_log(strLog);
       return -1;
    }

    if(!sub)
    {
       sprintf(strLog,"%s\r\n","sub is null");
       record_error_log(strLog);
       return -1;
    }


    if(mopush_invalid_char((char *)sub) !=0)
      return -1;

    strcpy(newTopic,topic_base);
    strcat(newTopic,clientName);
    strcat(newTopic,"/");
    strcat(newTopic,sub);

    return mopush_inernal_unsubscribe(mpush, mid,newTopic);
    

}
int mopush_set_appName(const char *appName)
{
  char strLog[100];
    if(!appName)
    {
       sprintf(strLog,"%s\r\n","appName is null");
       record_error_log(strLog);
       return -1;
    }

   if(strlen(appName) >50)
    {
       sprintf(strLog,"%s\r\n","appName is more than 50");
       record_error_log(strLog);
       return -1;
    }
   if(mopush_invalid_char(appName) !=0)
     return -1;
   strcpy(clientName,appName);
   return 0;
}

int mopushPubMsg2Client(mopush *mpush, const char *clientId, int qos,int payloadlen, const void *payload)
{
   char topic[MPUSH_MAX_TOPIC_LEN];
   int result;
   int mid;
   char strLog[100];
    if(!mpush)
    {
       sprintf(strLog,"%s\r\n","mpush is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }

    if(!clientId)
    {
       sprintf(strLog,"%s\r\n","clientId is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }

    if(!payload)
    {
       sprintf(strLog,"%s\r\n","payload is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }   
    if(qos<0 || qos>2)
    {
       sprintf(strLog,"%s\r\n","qos is not 0,1,2");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }      
   
   if(payloadlen < 0 || payloadlen > MPUSH_MAX_PAYLOAD_LEN)
    {
       sprintf(strLog,"%s\r\n","payload len error");
       record_error_log(strLog);
       return MPUSH_ERR_PAYLOAD_SIZE;
    }     

   strcpy(topic,topic_base);
   strcat(topic,clientName);
   strcat(topic,topic_point_prefix);
   strcat(topic,clientId);
   
   result=mopush_internal_publish(mpush, topic,payloadlen,payload,qos,false,MOPUSH_TYPE_PUBLISH_POINT);
   return result;
}

int mopushPubFile2Client(mopush *mpush, const char *clientId, int qos, const char *filename)
{
    char topic[MPUSH_MAX_TOPIC_LEN];
    int result;
    int mid;
    char strLog[100];
    if(!mpush)
    {
        sprintf(strLog,"%s\r\n","mpush is null");
        record_error_log(strLog);
        return MPUSH_ERR_INVAL;
    }
    
    if(!clientId)
    {
        sprintf(strLog,"%s\r\n","clientId is null");
        record_error_log(strLog);
        return MPUSH_ERR_INVAL;
    }
    
    if(!filename)
    {
        sprintf(strLog,"%s\r\n","filename is null");
        record_error_log(strLog);
        return MPUSH_ERR_INVAL;
    }
    if(qos<0 || qos>2)
    {
        sprintf(strLog,"%s\r\n","qos is not 0,1,2");
        record_error_log(strLog);
        return MPUSH_ERR_INVAL;
    }
    
    
    strcpy(topic,topic_base);
    strcat(topic,clientName);
    strcat(topic,topic_point_prefix);
    strcat(topic,clientId);
    
    result=mopush_internal_publish_file(mpush, topic,filename,qos,false);
    return result;
}

int mopushPubFileToCircleMsg(mopush *mpush, const char *name, const char *filename)
{
    int mid;
    char topic[MPUSH_MAX_TOPIC_LEN];
    int result;
    bool couldSend=false;
    char strLog[100];
    FILE *sp ;
    char *saveptr = NULL;
    char existedTopic[MPUSH_MAX_TOPIC_NUM*MPUSH_MAX_TOPIC_LEN];
    char *newSingletopic[MPUSH_MAX_TOPIC_NUM];
    int i=0;
    
    if(!mpush)
    {
        sprintf(strLog,"%s\r\n","mpush is null");
        record_error_log(strLog);
        return MPUSH_ERR_INVAL;
    }
    
    if(!name)
    {
        sprintf(strLog,"%s\r\n","name is null");
        record_error_log(strLog);
        return MPUSH_ERR_INVAL;
    }
    
    if(!filename)
    {
        sprintf(strLog,"%s\r\n","payload is null");
        record_error_log(strLog);
        return MPUSH_ERR_INVAL;
    }
    
    if(mopush_invalid_char(name) !=0)
        return -1;
    
    strcpy(topic,topic_base);
    strcat(topic,clientName);
    strcat(topic,topic_circle_prefix);
    strcat(topic,name);
    
    // printf("___publish topic=%s\n",topic);
    
    //check if I am in this circle
    
    if((sp = fopen(topicListFile,"r")) == NULL)
    {
        couldSend=false;
        //   printf("___false\n");
    }
    else
    {
        fseek(sp,0L,SEEK_SET);
        fgets(existedTopic,MPUSH_MAX_TOPIC_NUM*MPUSH_MAX_TOPIC_LEN,sp);
        // printf("all topic=%s\n",existedTopic);
        
        newSingletopic[i] = strtok_r(existedTopic, ";", &saveptr);
        
        while(newSingletopic[i] )
        {
            //       printf("___new singletopic=%s\n",newSingletopic[i]);
            if(strncmp(newSingletopic[i],topic,strlen(topic)) == 0)
            {
                couldSend=true;
                break;
            }
            
            i++;
            newSingletopic[i] = strtok_r(NULL, ";", &saveptr);
        }
    }
    // printf("___publish__i=%d\n",i);
    if(couldSend == false)
    {
        printf("could not send message to this circle\n");
        return -1;    
    }   
    
    result=mopush_internal_publish_file(mpush, topic,filename,CIRCLE_QOS,false);
    
    return result;
}

int mopushPubMsgServerForApns(mopush *mpush, char *clientId, int qos,int payloadlen, const void *payload,const char *type)
{
    char topic[MPUSH_MAX_TOPIC_LEN];
    int result;
    int mid;
    char strLog[100];
    if(!mpush)
    {
        sprintf(strLog,"%s\r\n","mpush is null");
        record_error_log(strLog);
        return MPUSH_ERR_INVAL;
    }
    
    if(!clientId)
    {
        sprintf(strLog,"%s\r\n","clientId is null");
        record_error_log(strLog);
        return MPUSH_ERR_INVAL;
    }
    
    if(!payload)
    {
        sprintf(strLog,"%s\r\n","payload is null");
        record_error_log(strLog);
        return MPUSH_ERR_INVAL;
    }
    if(qos<0 || qos>2)
    {
        sprintf(strLog,"%s\r\n","qos is not 0,1,2");
        record_error_log(strLog);
        return MPUSH_ERR_INVAL;
    }
    
    if(payloadlen < 0 || payloadlen > MPUSH_MAX_PAYLOAD_LEN)
    {
        sprintf(strLog,"%s\r\n","payload len error");
        record_error_log(strLog);
        return MPUSH_ERR_PAYLOAD_SIZE;
    }
    
    strcpy(topic,server_topic_base);
    strcat(topic,clientName);
    strcat(topic,type);
    strcat(topic,clientId);
    
    result=mopush_internal_publish(mpush, topic,payloadlen,payload,qos,false,MOPUSH_TYPE_PUBLISH_POINT);
    return result;
}

int mopushPubTokenToServerForApns(mopush *mpush,int payloadlen,const char *token)
{
    return mopushPubMsgServerForApns(mpush, "mpushS", 1,payloadlen, token,server_type_0);
}

int mopushPubMessageTipToClient(mopush *mpush,const char *clientId,int qos,int payloadlen,const void *payload)
{
    return mopushPubMsgServerForApns(mpush, (char *)clientId, qos,payloadlen, payload,server_type_1);
}

int mopushPubCircleMessageTip(mopush *mpush,const char *circleName,int qos,int payloadlen,const void *payload)
{
    return mopushPubMsgServerForApns(mpush, (char *)circleName, qos,payloadlen, payload,server_type_2);
}

int mopushJoinCircleTip(mopush *mpush,const char *circleName,int qos,int payloadlen,const void *payload)
{
    return mopushPubMsgServerForApns(mpush, (char *)circleName, qos,payloadlen, payload,server_type_3);
}

int mopushDelCircleTip(mopush *mpush,const char *circleName,int qos,int payloadlen,const void *payload)
{
    return mopushPubMsgServerForApns(mpush, (char *)circleName, qos,payloadlen, payload,server_type_4);
}

int mopushQuitCircleTip(mopush *mpush,const char *circleName,int qos,int payloadlen,const void *payload)
{
    return mopushPubMsgServerForApns(mpush, (char *)circleName, qos,payloadlen, payload,server_type_5);
}

int mopushJoinCircle(mopush *mpush, const char *name)
{
  char strLog[100];
	char topic[MPUSH_MAX_TOPIC_LEN];
  char topicPub[MPUSH_MAX_TOPIC_LEN];
  char payload[MOPUSH_CIRCLE_PAYLOAD_LEN];
	int result;
	int mid;
	
    if(!mpush)
    {
       sprintf(strLog,"%s\r\n","mpush is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }

    if(!name)
    {
       sprintf(strLog,"%s\r\n","name is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }

  if(mopush_invalid_char(name) !=0)
    return -1;    
  strcpy(topic,topic_base);
  strcat(topic,clientName);
  strcat(topic,topic_circle_prefix);
  strcat(topic,name);      
      
	result= mopush_internal_subscribe(mpush,&mid,topic,CIRCLE_QOS);

    strcpy(topicPub,topic_base);
    strcat(topicPub,clientName);
    strcat(topicPub,topic_circle_prefix);
    strcat(topicPub,name);      
    strcpy(payload,topicPub);
	  result=mopush_internal_publish(mpush, topicPub,strlen(payload),payload,CIRCLE_QOS,false,MOPUSH_TYPE_PUBLISH_GROUP_JOIN);
	return result;
}
    
int mopushCreateWholeCircle(mopush *mpush, char *name)
{
	char payload[MOPUSH_CIRCLE_PAYLOAD_LEN];
	int i=0;
  char topic[MPUSH_MAX_TOPIC_LEN];
  int result;
  int mid;  
  char strLog[100];

    if(!mpush)
    {
       sprintf(strLog,"%s\r\n","mpush is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }

    if(!name)
    {
       sprintf(strLog,"%s\r\n","name is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }
	
  if(mopush_invalid_char(name) !=0)
    return -1;    

	strcpy(payload,name);

    strcpy(topic,topic_base);
    strcat(topic,clientName);
    strcat(topic,topic_app_all_prefix);
    strcat(topic,topic_circle_topic);
    mopush_internal_publish(mpush, topic,strlen(payload),payload,CIRCLE_QOS,false,MOPUSH_TYPE_PUBLISH_GROUP_ADD);
  	
    mopushJoinCircle(mpush,name);
	  return MPUSH_ERR_SUCCESS;  
} 
int mopushCreateCircle(mopush *mpush, const char *name , int num , char *idlist[])
{
	char payload[MOPUSH_CIRCLE_PAYLOAD_LEN];
	int i=0;
    char topic[MPUSH_MAX_TOPIC_LEN];
    int result;
    int mid;  
    char strLog[100];

    if(!mpush)
    {
       sprintf(strLog,"%s\r\n","mpush is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }

    if(!name)
    {
       sprintf(strLog,"%s\r\n","name is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }
  
//    if(num<1)
//    {
//       sprintf(strLog,"%s\r\n","number is less than 1");
//       record_error_log(strLog);
//       return MPUSH_ERR_INVAL;
//    }
//
//    if(!idlist)
//    {
//       sprintf(strLog,"%s\r\n","clientid list is null");
//       record_error_log(strLog);
//       return MPUSH_ERR_INVAL;
//    }	
  if(mopush_invalid_char(name) !=0)
    return -1;    

	strcpy(payload,name);
	for(i=0;i<num;i++)
    {
	    topic[0]='\0';
      strcpy(topic,topic_base);
      strcat(topic,clientName);
      strcat(topic,topic_point_prefix);
      strcat(topic,idlist[i]);
      strcat(topic,topic_circle_topic);
      mopush_internal_publish(mpush, topic,strlen(payload),payload,CIRCLE_QOS,false,MOPUSH_TYPE_PUBLISH_GROUP_ADD);
  }
	
  mopushJoinCircle(mpush,name);
	return MPUSH_ERR_SUCCESS;  
} 

int mopushDelCircle(mopush *mpush, const char *name)
{
    char payload[MOPUSH_CIRCLE_PAYLOAD_LEN];
    char topic[MPUSH_MAX_TOPIC_LEN];
    int mid;
    int result;
    char strLog[100];

    if(!mpush)
    {
       sprintf(strLog,"%s\r\n","mpush is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }

    if(!name)
    {
       sprintf(strLog,"%s\r\n","name is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }    
  
    if(mopush_invalid_char(name) !=0)
      return -1;    

    strcpy(topic,topic_base);
    strcat(topic,clientName);
    strcat(topic,topic_circle_prefix);
    strcat(topic,name);  
    
	  strcpy(payload,name);    
    
	  result=mopush_internal_publish(mpush,topic,strlen(payload),payload,CIRCLE_QOS,false,MOPUSH_TYPE_PUBLISH_GROUP_DEL);
	  return result;
}



int mopushQuitCircle(mopush *mpush , const char *name)
{
	char topic[MPUSH_MAX_TOPIC_LEN];
  char topicPub[MPUSH_MAX_TOPIC_LEN];
  char payload[MOPUSH_CIRCLE_PAYLOAD_LEN];
	int result;
	int mid;
    char strLog[100];

    if(!mpush)
    {
       sprintf(strLog,"%s\r\n","mpush is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }

    if(!name)
    {
       sprintf(strLog,"%s\r\n","name is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }

  if(mopush_invalid_char(name) !=0)
    return -1;    	    		
  strcpy(topic,topic_base);
  strcat(topic,clientName);
  strcat(topic,topic_circle_prefix);
  strcat(topic,name);      
	result= mopush_inernal_unsubscribe(mpush,&mid,topic);

    strcpy(topicPub,topic_base);
    strcat(topicPub,clientName);
    strcat(topicPub,topic_circle_prefix);
    strcat(topicPub,name);      
    strcpy(payload,topicPub);

    result=mopush_internal_publish(mpush, topicPub,strlen(payload),payload,CIRCLE_QOS,false,MOPUSH_TYPE_PUBLISH_GROUP_QUIT);

	return result;
	
}

int mopushPubCircleMsg(mopush *mpush, const char *name, int payloadlen, const void *payload)
{
   int mid;
   char topic[MPUSH_MAX_TOPIC_LEN];
   int result;
   bool couldSend=false;
    char strLog[100];
	FILE *sp ;
	char *saveptr = NULL;
	char existedTopic[MPUSH_MAX_TOPIC_NUM*MPUSH_MAX_TOPIC_LEN];
	char *newSingletopic[MPUSH_MAX_TOPIC_NUM];    
	int i=0;

    if(!mpush)
    {
       sprintf(strLog,"%s\r\n","mpush is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }

    if(!name)
    {
       sprintf(strLog,"%s\r\n","name is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }

    if(!payload)
    {
       sprintf(strLog,"%s\r\n","payload is null");
       record_error_log(strLog);
       return MPUSH_ERR_INVAL;
    }


   if(payloadlen < 0 || payloadlen > MPUSH_MAX_PAYLOAD_LEN)
   {
       sprintf(strLog,"%s\r\n","payloadlen is invalid");
       record_error_log(strLog);
       return MPUSH_ERR_PAYLOAD_SIZE;
    }


   if(mopush_invalid_char(name) !=0)
    return -1;    

    strcpy(topic,topic_base);
    strcat(topic,clientName);
    strcat(topic,topic_circle_prefix);
    strcat(topic,name);      
/*
   // printf("___publish topic=%s\n",topic);
    
    //check if I am in this circle

    if((sp = fopen(topicListFile,"r")) == NULL)
    {
      couldSend=false;
   //   printf("___false\n");  
    }
    else
    {
      fseek(sp,0L,SEEK_SET);     
      fgets(existedTopic,MPUSH_MAX_TOPIC_NUM*MPUSH_MAX_TOPIC_LEN,sp); 
   // printf("all topic=%s\n",existedTopic);
     
      newSingletopic[i] = strtok_r(existedTopic, ";", &saveptr);
      
      while(newSingletopic[i] )
      {
 //       printf("___new singletopic=%s\n",newSingletopic[i]);
        if(strncmp(newSingletopic[i],topic,strlen(topic)) == 0)
        {
         couldSend=true;
         break;
        }
        
        i++;
        newSingletopic[i] = strtok_r(NULL, ";", &saveptr);
      }    
    }
   // printf("___publish__i=%d\n",i);
    if(couldSend == false)
    {
	   printf("could not send message to this circle\n");
	   return -1;    
	}   
*/
    result=mopush_internal_publish(mpush,topic,payloadlen,payload,CIRCLE_QOS,false,MOPUSH_TYPE_PUBLISH_GROUP_MSG);
    return result;
}


mopush *mopush_new(const char *id, bool clean_session, void *userdata)
{

    char strLog[100];
     if(!id)
    {
       sprintf(strLog,"%s\r\n","parameter 0(clientid) is null");
       record_error_log(strLog);
       return NULL;
    }
  //printf("id =%s\n",id);
  if(mopush_invalid_char((char*)id) !=0)
    return NULL;     
	
  mopush *mopushPtr=mosquitto_new(id,clean_session,userdata);
	return mopushPtr;
}


void mopush_connect_callback_set(mopush *mpush, void (*on_connect)(mopush *, void *, int))
{   
	mosquitto_connect_callback_set(mpush,on_connect);
	return;
	
}

void mopush_new_message_callback(struct mosquitto *mosq, void *obj, const struct mosquitto_message *message)
{
    char clientid[MPUSH_MAX_CLIENTID_LEN];
    char date[MPUSH_MAX_DATE_LEN];
    char *tmpPtr;
    int headLen=0;
    int mopushType=0;
    int i=0,j=0;
    int m=0;
    char *clientId;
    mopush_message tmpMpushMsg;
    /*
     printf("topic1=%s\n",(char*)(message->topic));
     
     printf("payloadlen=%d",message->payloadlen);
     */
    if(new_message)
    {
        tmpPtr=(char*)(message->payload);
        /*
         for(i=0;i<message->payloadlen;i++)
         printf("payload[%d]=0x%x\n",i,tmpPtr[i]);
         */
        tmpMpushMsg.mid=message->mid;
        tmpMpushMsg.qos=message->qos;
        tmpMpushMsg.retain=message->retain;
        
        // strcpy(tmpMpushMsg.topic,message->topic);
        
        headLen=((tmpPtr[0] & 0xff) << 24) |  ((tmpPtr[1] & 0xff) << 16) | ((tmpPtr[2] & 0xff) << 8) | (tmpPtr[3] & 0xff);
        
        tmpMpushMsg.mopushType=((tmpPtr[4] & 0xff) << 24) |  ((tmpPtr[5] & 0xff) << 16) | ((tmpPtr[6] & 0xff) << 8) | (tmpPtr[7] & 0xff);
        //   printf("mopushtype=%d\n",tmpMpushMsg.mopushType);
        
        memcpy(tmpMpushMsg.date,(char *)&tmpPtr[MOPUSH_LEN+MOPUSH_TYPE_LEN],MOPUSH_DATE_LEN);
        tmpMpushMsg.date[MOPUSH_DATE_LEN]='\0';
        memcpy(tmpMpushMsg.senderId,(char *)&tmpPtr[MOPUSH_LEN+MOPUSH_TYPE_LEN+MOPUSH_DATE_LEN],headLen-MOPUSH_LEN-MOPUSH_TYPE_LEN-MOPUSH_DATE_LEN);
        tmpMpushMsg.senderId[headLen-MOPUSH_LEN-MOPUSH_TYPE_LEN-MOPUSH_DATE_LEN]='\0';
        
        
        clientId=mosquitto_get_local_clientid(mosq);
        printf("received\n");
        if(clientId == NULL)
        {
            printf("111\n");
            return;
        }
        else
        {
            
            if(strcmp(clientId,tmpMpushMsg.senderId)==0)
            {
                // printf("it's self return");
                return;
            }
            
        }
        
        tmpMpushMsg.payloadlen = message->payloadlen - headLen;
        
        memcpy(tmpMpushMsg.payload, (char *)&tmpPtr[headLen],tmpMpushMsg.payloadlen);
        
        switch(tmpMpushMsg.mopushType)
        {
            case MOPUSH_TYPE_PUBLISH_GROUP_ADD:
            case MOPUSH_TYPE_PUBLISH_GROUP_DEL:
                
                memcpy(tmpMpushMsg.circleName,tmpMpushMsg.payload,tmpMpushMsg.payloadlen);
                /*
                 printf("payloadlen=%d\n",tmpMpushMsg.payloadlen);
                 for(m=0;m<tmpMpushMsg.payloadlen;m++)
                 printf("tmpMpushMsg.circleName[%d]=%c\n",m,tmpMpushMsg.circleName[m]);
                 */
                tmpMpushMsg.circleName[tmpMpushMsg.payloadlen]='\0';
                break;
            case MOPUSH_TYPE_PUBLISH_GROUP_MSG:
            case MOPUSH_TYPE_PUBLISH_GROUP_JOIN:
            case MOPUSH_TYPE_PUBLISH_GROUP_QUIT:
            case MOPUSH_TYPE_PUBLISH_FILE:
            {
                char *oldSingleItem[MPUSH_MAX_TOPIC_NUM];
                char *saveptr = NULL;
                
                oldSingleItem[j] = strtok_r(message->topic, "/", &saveptr);
                
                while(oldSingleItem[j] )
                {
                    //  printf("___item[%d]=%s\n",j,oldSingleItem[j]);
                    j++;
                    oldSingleItem[j] = strtok_r(NULL, "/", &saveptr);
                }
                
                if( strcmp(oldSingleItem[0],"mobridge")==0 &&  strcmp(oldSingleItem[1],clientName)==0 && strcmp(oldSingleItem[2],"comm")==0 && strcmp(oldSingleItem[3],"circle")==0)
                    strcpy(tmpMpushMsg.circleName,oldSingleItem[4]);
                else {
                    tmpMpushMsg.circleName[0]='\0';
                }
            }
                break;
                
            default:
                tmpMpushMsg.circleName[0]='\0';
        }
        
        (*new_message)(mosq,obj,&tmpMpushMsg);	 
    }
}

void mopush_message_callback_set(mopush *mpush, void (*on_message)(mopush *, void *, mopush_message *))
{
	new_message=on_message;
	mosquitto_message_callback_set(mpush, mopush_new_message_callback);

	return;
}

void mopush_read_topic()
{


  char topic1[MPUSH_MAX_TOPIC_LEN];
    char topic2[MPUSH_MAX_TOPIC_LEN];
    FILE *sp ;
    char existedTopic[MPUSH_MAX_TOPIC_NUM*MPUSH_MAX_TOPIC_LEN];
    char *newSingletopic[MPUSH_MAX_TOPIC_NUM];
    char *singleOneTopic[10],*tmpPtr;
    char *saveptr = NULL;
    int i=0,j=0;
    int singleOneQos=0;
        
/*
    if((sp = fopen(topicListFile,"a+")) == NULL)
       return;

    fseek(sp,0L,SEEK_SET);     
    fgets(existedTopic,MPUSH_MAX_TOPIC_NUM*MPUSH_MAX_TOPIC_LEN,sp); 
    
     
    newSingletopic[i] = strtok_r(existedTopic, ";", &saveptr);
    while(newSingletopic[i] )
    {
        j=0;
        singleOneTopic[j] =  strtok_r(newSingletopic[i], ":", &tmpPtr);  
        while(singleOneTopic[j])
        {
           
          j++;
         
          singleOneTopic[j] = strtok_r(NULL, ":", &tmpPtr);
        }
        singleOneQos=atoi(singleOneTopic[1]);
        printf("topic[%d]=%s,qos=%d\n",i,singleOneTopic[0],singleOneQos);
       // mosquitto_subscribe(mpush, NULL, singleOneTopic[0], singleOneQos);
        i++;
        newSingletopic[i] = strtok_r(NULL, ";", &saveptr);
    }           
     
    fclose(sp); 
 */
}

void mopushSubOneself(mopush *mpush)
{
    char topic1[MPUSH_MAX_TOPIC_LEN];
    char topic2[MPUSH_MAX_TOPIC_LEN];
    char *clientId;
    
    if(!mpush)
        return;
    
    strcpy(topic1,topic_base);
    strcat(topic1,clientName);
    strcat(topic1,topic_point_prefix);
    
    clientId=mosquitto_get_local_clientid(mpush);
    if(clientId != NULL)
        
    strcat(topic1,clientId);
    strcat(topic1,topic_all_prefix);
    mosquitto_subscribe(mpush, NULL, topic1, CIRCLE_QOS);
    
    strcpy(topic2,topic_base);
    strcat(topic2,clientName);
    strcat(topic2,topic_app_all_prefix);
    
    strcat(topic2,topic_all_prefix);
    mosquitto_subscribe(mpush, NULL, topic2, CIRCLE_QOS);
}

void mopush_connect_callback(mopush *mpush, void *obj, int result)
{
	char topic1[MPUSH_MAX_TOPIC_LEN];
    char topic2[MPUSH_MAX_TOPIC_LEN];
    FILE *sp ;
    char existedTopic[MPUSH_MAX_TOPIC_NUM*MPUSH_MAX_TOPIC_LEN];
    char *newSingletopic[MPUSH_MAX_TOPIC_NUM];
    char *singleOneTopic[10],*tmpPtr;
    char *saveptr = NULL;
    int i=0,j=0;
    int singleOneQos=0;
    char *clientId;            

	  if(!mpush)
	    return;


	  strcpy(topic1,topic_base);
    strcat(topic1,clientName);
    strcat(topic1,topic_point_prefix);

    clientId=mosquitto_get_local_clientid(mpush);
    if(clientId != NULL)
    
    strcat(topic1,clientId);
    strcat(topic1,topic_all_prefix);
    mosquitto_subscribe(mpush, NULL, topic1, CIRCLE_QOS);

	  strcpy(topic2,topic_base);
    strcat(topic2,clientName);
    strcat(topic2,topic_app_all_prefix);

    strcat(topic2,topic_all_prefix);
    mosquitto_subscribe(mpush, NULL, topic2, CIRCLE_QOS);
/*
    if((sp = fopen(topicListFile,"a+")) == NULL)
       return;

    fseek(sp,0L,SEEK_SET);     
    fgets(existedTopic,MPUSH_MAX_TOPIC_NUM*MPUSH_MAX_TOPIC_LEN,sp); 
    //printf("read all topic=%s\n",existedTopic);
     
    newSingletopic[i] = strtok_r(existedTopic, ";", &saveptr);
    while(newSingletopic[i] )
    {
        //if(debug_prn)
       // printf("old topic[%d]=%s\n",i,newSingletopic[i]);
        j=0;
        singleOneTopic[j] =  strtok_r(newSingletopic[i], ":", &tmpPtr);  
        while(singleOneTopic[j])
        {
	         
	        j++;
	       
	        singleOneTopic[j] = strtok_r(NULL, ":", &tmpPtr);
	      }
        singleOneQos=atoi(singleOneTopic[1]);
       // printf("sub old topic  =%s,qos=%d\n",singleOneTopic[0],singleOneQos);
        mosquitto_subscribe(mpush, NULL, singleOneTopic[0], singleOneQos);
        i++;
        newSingletopic[i] = strtok_r(NULL, ";", &saveptr);
    }           
     
    fclose(sp);	 
 */
}

int mopush_connect(mopush *mpush, const char *host, int port, int keepalive)
{
  int result;
  
  if(!mpush || !host) 
      return MPUSH_ERR_INVAL;

  if(strcmp(clientName,"") ==0)
  {
    printf("appname is not set\n");
    return -1;
  }
//  mopush_connect_callback_set(mpush, mopush_connect_callback);
    
  result=mosquitto_connect(mpush,host,port,keepalive);
  return result;
}


int mopush_loop(mopush *mpush, int timeout)
{
    int result;
    int max_packets=1;
    result=mosquitto_loop(mpush,timeout,max_packets);
    return result;
}


int mopush_reconnect(mopush *mpush)
{
    int result= mosquitto_reconnect(mpush);
    return result;
}

void mopush_destroy(mopush *mpush)
{
    mosquitto_destroy(mpush);
    return;
}

int mopush_lib_cleanup(void)
{
    int result=mosquitto_lib_cleanup();
    return result;
}



int mopush_will_set(mopush *mpush, const char *topic, int payloadlen, const void *payload, int qos, bool retain)
{
    int result;
    int newLen;
    int i=0;

    if(!mpush || !topic || !payload)
      return -1;

    newLen=encapayload(mpush,payloadlen,(char *)payload,MOPUSH_TYPE_WILL_MSG);
    if(newLen < 0)
    {
      printf("error\n");
      return -1;
    } 

    result=mosquitto_will_clear(mpush);
    result=mosquitto_will_set(mpush, topic, newLen,mpushPayLoad,2, 0);   
           
    return result;
}


int mopush_usrname_pw_set(mopush *mpush, const char *username, const char *password)
{
	int result=mosquitto_username_pw_set(mpush,username,password);
	return result;

}

void mopush_publish_callback_set(mopush *mpush, void (*on_publish)(mopush *, void *, int))
{   
  mosquitto_publish_callback_set(mpush,on_publish);
  return;
  
}

void mopush_subscribe_callback_set(mopush *mpush, void (*on_subscribe)(mopush *, void *, int, int, const int *))
{
    mosquitto_subscribe_callback_set(mpush, on_subscribe);
}

void mopush_unsubscribe_callback_set(mopush *mpush, void (*on_unsubscribe)(mopush *, void *, int))
{
	mosquitto_unsubscribe_callback_set(mpush,on_unsubscribe);
	return;
}


void mopush_disconnect_callback_set(mopush *mpush, void (*on_disconnect)(mopush*, void *, int))
{
	mosquitto_disconnect_callback_set(mpush,on_disconnect);
	return;
}




