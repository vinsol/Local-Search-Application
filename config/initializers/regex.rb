#Regular Expressions

EMAIL = /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i
PHONE = /^[\(\)0-9\- \+\.]{10}$/
URL = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix

SEARCH_REGEX = /(?:([a-zA-Z0-9]*[\s,]+)*)([a-zA-Z0-9]+)$/