PROJECT_NAME = regex_testbed
GUNNET_LIBS = -lgnunettestbed \
	-lgnunetdht \
	-lgnunetutil \
	-lgnunetregex

.PHONY: all clean

all:
	gcc -o ${PROJECT_NAME} ${PROJECT_NAME}.c ${GUNNET_LIBS} -Wall -g

clean:
	rm -f ${PROJECT_NAME}
