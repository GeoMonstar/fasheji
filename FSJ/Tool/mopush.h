
#ifndef _MOPUSH_H_
#define _MOPUSH_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <stdbool.h>


#define libmopush_EXPORTS
#define MPUSH_MAX_PAYLOAD_LEN   2000
#define CIRCLE_QOS              2
#define MPUSH_MAX_TOPIC_LEN     500
#define MPUSH_MAX_DATE_LEN      30
#define MPUSH_MAX_CLIENTID_LEN  60
#define MPUSH_MAX_TOPIC_NUM     50

#define MOPUSH_MSG_TYPE  10
#define MOPUSH_TYPE_EVENT  MOPUSH_MSG_TYPE+1
#define MOPUSH_TYPE_ACK  MOPUSH_MSG_TYPE+2
#define MOPUSH_TYPE_RECV  MOPUSH_MSG_TYPE+3
#define MOPUSH_TYPE_CONNECT_SUB  MOPUSH_MSG_TYPE+4
#define MOPUSH_TYPE_CONNECT_PUB  MOPUSH_MSG_TYPE+5
#define MOPUSH_TYPE_PUBLISH_NORMAL  MOPUSH_MSG_TYPE+6
#define MOPUSH_TYPE_PUBLISH_GROUP_ADD  MOPUSH_MSG_TYPE+7
#define MOPUSH_TYPE_PUBLISH_GROUP_DEL  MOPUSH_MSG_TYPE+8
#define MOPUSH_TYPE_PUBLISH_GROUP_JOIN  MOPUSH_MSG_TYPE+9
#define MOPUSH_TYPE_PUBLISH_GROUP_MSG  MOPUSH_MSG_TYPE+10
#define MOPUSH_TYPE_PUBLISH_GROUP_QUIT  MOPUSH_MSG_TYPE+11
#define MOPUSH_TYPE_PUBLISH_POINT  MOPUSH_MSG_TYPE+12
#define MOPUSH_TYPE_UNSUBSCRIBE_NORMAL  MOPUSH_MSG_TYPE+13
#define MOPUSH_TYPE_UNSUBSCRIBE_CIRCLE  MOPUSH_MSG_TYPE+14
#define MOPUSH_TYPE_SUBSCRIBE_NORMAL  MOPUSH_MSG_TYPE+15
#define MOPUSH_TYPE_SUBSCRIBE_CIRCLE_JOIN  MOPUSH_MSG_TYPE+16
#define MOPUSH_TYPE_SUBSCRIBE_DEFAULT_TOPICS  MOPUSH_MSG_TYPE+17
#define MOPUSH_TYPE_SUBSCRIBE_RE_ALL_TOPICS  MOPUSH_MSG_TYPE+18
#define MOPUSH_TYPE_DISCONNECT_SUB  MOPUSH_MSG_TYPE+19
#define MOPUSH_TYPE_DISCONNECT_PUB  MOPUSH_MSG_TYPE+20
#define MOPUSH_TYPE_WILL_MSG             206

typedef struct mopush_message{
	int mid;
	char circleName[MPUSH_MAX_TOPIC_LEN];
	char payload[MPUSH_MAX_PAYLOAD_LEN];
	int payloadlen;
	int qos;
	bool retain;
	int mopushType;
	char date[MPUSH_MAX_DATE_LEN];
	char senderId[MPUSH_MAX_CLIENTID_LEN];

} mopush_message;

enum mpush_err_t {
	MPUSH_ERR_CONN_PENDING = -1,
	MPUSH_ERR_SUCCESS = 0,
	MPUSH_ERR_NOMEM = 1,
	MPUSH_ERR_PROTOCOL = 2,
	MPUSH_ERR_INVAL = 3,
	MPUSH_ERR_NO_CONN = 4,
	MPUSH_ERR_CONN_REFUSED = 5,
	MPUSH_ERR_NOT_FOUND = 6,
	MPUSH_ERR_CONN_LOST = 7,
	MPUSH_ERR_TLS = 8,
	MPUSH_ERR_PAYLOAD_SIZE = 9,
	MPUSH_ERR_NOT_SUPPORTED = 10,
	MPUSH_ERR_AUTH = 11,
	MPUSH_ERR_ACL_DENIED = 12,
	MPUSH_ERR_UNKNOWN = 13,
	MPUSH_ERR_ERRNO = 14,
	MPUSH_ERR_EAI = 15
};

typedef struct mosquitto mopush;


static const char topic_base[] = "/mobridge/";
static const char topic_point_prefix[] = "/comm/point/";
static const char topic_circle_prefix[] = "/comm/circle/";
static const char topic_app_all_prefix[] = "/comm/all";
static const char topic_circle_topic[] = "/circle";
static const char topic_all_prefix[] = "/#";

libmopush_EXPORTS int mopush_lib_init(void);

libmopush_EXPORTS mopush *mopush_new(const char *id, bool clean_session, void *userdata);

libmopush_EXPORTS void mopush_connect_callback_set(mopush *mpush, void (*on_connect)(mopush *, void *, int));

libmopush_EXPORTS void mopush_message_callback_set(mopush *mpush, void (*on_message)(mopush *, void *,mopush_message *));


libmopush_EXPORTS int mopush_connect(mopush *mpush, const char *host, int port, int keepalive);


libmopush_EXPORTS int mopush_loop(mopush *mpush, int timeout);

libmopush_EXPORTS int mopush_reconnect(mopush *mpush);

libmopush_EXPORTS void mopush_destroy(mopush *mpush);

libmopush_EXPORTS int mopush_lib_cleanup(void);

libmopush_EXPORTS int mopush_subscribe(mopush *mpush, int *mid, const char *sub, int qos);

libmopush_EXPORTS int mopush_unsubscribe(mopush *mpush, int *mid, const char *sub);

libmopush_EXPORTS int mopush_publish(mopush *mpush, const char *topic, int payloadlen, const void *payload, int qos, bool retain);

libmopush_EXPORTS int mopushPubMsg2Client(mopush *mpush, char *clientId, int qos,int payloadlen, const void *payload);

libmopush_EXPORTS int mopushJoinCircle(mopush *mpush, char *name);

libmopush_EXPORTS int mopushCreateCircle(mopush *mpush, char *name , int num , char *idlist[]);

libmopush_EXPORTS int mopushDelCircle(mopush *mpush, char *name);

libmopush_EXPORTS int mopushQuitCircle(mopush *mpush , char *name);

libmopush_EXPORTS int mopushPubCircleMsg(mopush *mpush, char *name, int payloadlen, char *payload);

libmopush_EXPORTS int mopush_usrname_pw_set(mopush *mpush, const char *username, const char *password);

libmopush_EXPORTS int mopush_will_set(mopush *mpush, const char *topic, int payloadlen, const void *payload, int qos, bool retain);

libmopush_EXPORTS int mopush_set_appName(char *appName);
libmopush_EXPORTS void mopush_publish_callback_set(mopush *mpush, void (*on_publish)(mopush *, void *, int));
int encapayload(mopush *mpush, int len, char *payload, int type);
libmopush_EXPORTS void mopush_disconnect_callback_set(mopush *mpush, void (*on_disconnect)(mopush*, void *, int));
libmopush_EXPORTS void mopush_unsubscribe_callback_set(mopush *mpush, void (*on_unsubscribe)(mopush *, void *, int));
#endif
