/* runtime.c -- a portable runtime library for Tiger.  It leaves
 *              a few low-level system calls undefined:
 *
 *                 malloc
 *                 getchar
 *                 putchar
 *                 printf
 *                 exit
 *
 * $Id: runtime.c,v 1.1 2002/08/25 05:06:41 shivers Exp $
 */


int *tig_initArray(int size, int init)
{int i;
 int *a = (int *)malloc((size+1)*sizeof(int));
 a[0] = size;
 for(i=1;i<size+1;i++) a[i]=init;
 return a;
}

int *tig_allocRecord(int size)
{int i;
 int *p, *a;
 p = a = (int *)malloc(size);
 for(i=0;i<size;i+=sizeof(int)) *p++ = 0;
 return a;
}

struct string {int length; unsigned char chars[1];};

int tig_stringEqual(struct string *s, struct string *t)
{int i;
 if (s==t) return 1;
 if (s->length!=t->length) return 0;
 for(i=0;i<s->length;i++) if (s->chars[i]!=t->chars[i]) return 0;
 return 1;
}

#undef putchar
void tig_print(struct string *s)
{int i; unsigned char *p=s->chars;
 for(i=0;i<s->length;i++,p++) putchar(*p);
}


struct string consts[256]= {{0,""} };
struct string empty={0,""};

int main()
{int i;
 for(i=0;i<256;i++)
   {consts[i].length=1;
    consts[i].chars[0]=i;
   }
 return tig_main(0 /* static link */);
}

int tig_ord(struct string *s)
{
 if (s->length==0) return -1;
 else return s->chars[0];
}

struct string *tig_chr(int i)
{
     if (i<0 || i>=256)
     { exit(1);}
 return consts+i;
}

int tig_size(struct string *s)
{ 
 return s->length;
}

struct string *tig_substring(struct string *s, int first, int n)
{
 if (first<0 || first+n>s->length)
   {printf("substring([%d],%d,%d) out of range\n",s->length,first,n);
    exit(1);}
 if (n==1) return consts+s->chars[first];
 {struct string *t = (struct string *)malloc(sizeof(int)+n);
  int i;
  t->length=n;
  for(i=0;i<n;i++) t->chars[i]=s->chars[first+i];
  return t;
 }
}

struct string *tig_concat(struct string *a, struct string *b)
{
 if (a->length==0) return b;
 else if (b->length==0) return a;
 else {int i, n=a->length+b->length;
       struct string *t = (struct string *)malloc(sizeof(int)+n);
       t->length=n;
       for (i=0;i<a->length;i++)
	 t->chars[i]=a->chars[i];
       for(i=0;i<b->length;i++)
	 t->chars[i+a->length]=b->chars[i];
       return t;
     }
}

int tig_not(int i)
{ return !i;
}

struct string *tig_getchar()
{
 return tig_chr(getchar());
}