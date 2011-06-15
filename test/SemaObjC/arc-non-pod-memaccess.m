// RUN: %clang_cc1 -fobjc-nonfragile-abi -fsyntax-only -fobjc-arc -verify -fblocks -triple x86_64-apple-darwin10.0.0 %s
// RUN: %clang_cc1 -x objective-c++ -fobjc-nonfragile-abi -fsyntax-only -fobjc-arc -verify -fblocks -triple x86_64-apple-darwin10.0.0 %s

#ifdef __cplusplus
extern "C" {
#endif

void *memset(void *, int, __SIZE_TYPE__);
void *memmove(void *s1, const void *s2, __SIZE_TYPE__ n);
void *memcpy(void *s1, const void *s2, __SIZE_TYPE__ n);

#ifdef __cplusplus
}
#endif

void test(id __strong *sip, id __weak *wip, id __autoreleasing *aip,
          id __unsafe_unretained *uip, void *ptr) {
  // All okay.
  memset(sip, 0, 17);
  memset(wip, 0, 17);
  memset(aip, 0, 17);
  memset(uip, 0, 17);

  memcpy(sip, ptr, 17); // expected-warning{{destination for this 'memcpy' call is a pointer to lifetime-qualified type}} \
                      // expected-note{{explicitly cast the pointer to silence this warning}}
  memcpy(wip, ptr, 17); // expected-warning{{destination for this 'memcpy' call is a pointer to lifetime-qualified type}} \
                      // expected-note{{explicitly cast the pointer to silence this warning}}
  memcpy(aip, ptr, 17); // expected-warning{{destination for this 'memcpy' call is a pointer to lifetime-qualified type}} \
                      // expected-note{{explicitly cast the pointer to silence this warning}}
  memcpy(uip, ptr, 17);

  memcpy(ptr, sip, 17); // expected-warning{{source of this 'memcpy' call is a pointer to lifetime-qualified type}} \
                      // expected-note{{explicitly cast the pointer to silence this warning}}
  memcpy(ptr, wip, 17); // expected-warning{{source of this 'memcpy' call is a pointer to lifetime-qualified type}} \
                      // expected-note{{explicitly cast the pointer to silence this warning}}
  memcpy(ptr, aip, 17); // expected-warning{{source of this 'memcpy' call is a pointer to lifetime-qualified type}} \
                      // expected-note{{explicitly cast the pointer to silence this warning}}
  memcpy(ptr, uip, 17);

  memmove(sip, ptr, 17); // expected-warning{{destination for this 'memmove' call is a pointer to lifetime-qualified type}} \
                      // expected-note{{explicitly cast the pointer to silence this warning}}
  memmove(wip, ptr, 17); // expected-warning{{destination for this 'memmove' call is a pointer to lifetime-qualified type}} \
                      // expected-note{{explicitly cast the pointer to silence this warning}}
  memmove(aip, ptr, 17); // expected-warning{{destination for this 'memmove' call is a pointer to lifetime-qualified type}} \
                      // expected-note{{explicitly cast the pointer to silence this warning}}
  memmove(uip, ptr, 17);

  memmove(ptr, sip, 17); // expected-warning{{source of this 'memmove' call is a pointer to lifetime-qualified type}} \
                      // expected-note{{explicitly cast the pointer to silence this warning}}
  memmove(ptr, wip, 17); // expected-warning{{source of this 'memmove' call is a pointer to lifetime-qualified type}} \
                      // expected-note{{explicitly cast the pointer to silence this warning}}
  memmove(ptr, aip, 17); // expected-warning{{source of this 'memmove' call is a pointer to lifetime-qualified type}} \
                      // expected-note{{explicitly cast the pointer to silence this warning}}
  memmove(ptr, uip, 17);
}